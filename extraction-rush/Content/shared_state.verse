using { /Fortnite.com/Characters }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

# shared_state
# Estat compartit d'EXTRACTION RUSH, calcat del patró provat del mapa
# OnlyUp Naufragi (climb_shared_state.verse + player_climb_stats.verse +
# player_climb_manager.verse): mapes 'weak_map' a nivell de mòdul + classes
# 'persistable' + un helper sense estat que qualsevol device pot instanciar
# (tots comparteixen les mateixes taules).

# --- Dades persistents de l'estança (sobreviuen entre sessions) ---
# Com a Naufragi, els valors de weak_map han de ser persistables: només camps
# plans (int), res de tipus natius com 'transform'.
stash_data<public> := class<final><persistable>:
    Version<public>:int = 0
    Value<public>:int = 0            # Valor 💠 total acumulat a l'estança
    RunsExtracted<public>:int = 0    # Rondes extretes amb èxit

# --- Progrés de temporada persistent ---
season_data<public> := class<final><persistable>:
    Version<public>:int = 0
    XP<public>:int = 0
    Level<public>:int = 1

# Taules compartides a nivell de mòdul. Declarades un sol cop aquí perquè tots
# els devices del projecte (InventoryManager, MissionManager, leaderboard, HUD)
# llegeixin i escriguin els mateixos registres.
var StashMap<public>:weak_map(player, stash_data) = map{}
var SeasonMap<public>:weak_map(player, season_data) = map{}

# Valor recollit DURANT la ronda actual. No persistent per intenció: el
# reiniciem a 0 en extreure o en morir. Usa weak_map igualment perquè els
# 'var' de mòdul ho requereixen (int és persistable).
var RunValueMap<public>:weak_map(player, int) = map{}

# Empareja jugador i estança per poder ordenar-los junts al leaderboard
# (mateix patró que 'player_and_climb_stats' del Naufragi).
player_and_stash<public> := struct:
    Player<public>:player
    Stash<public>:stash_data

# Helper sense estat: llegeix/escriu les taules compartides. Cada device en pot
# crear el seu propi 'extraction_state{}' i tots operen sobre les mateixes dades
# (idèntic a com Naufragi usa 'player_climb_manager').
extraction_state<public> := class():

    # Assegura una entrada d'estança per al jugador. Segur cridar-ho més d'un cop.
    InitializePlayer<public>(Player:player):void=
        if (not StashMap[Player]):
            set StashMap[Player] = stash_data{}
        if (not SeasonMap[Player]):
            set SeasonMap[Player] = season_data{}

    InitializeAll<public>(Players:[]player):void=
        for (Player : Players):
            InitializePlayer(Player)

    # --- Botí de la ronda actual ---
    AddRunValue<public>(Player:player, Amount:int):void=
        Current := GetRunValue(Player)
        if (set RunValueMap[Player] = Current + Amount) {}

    GetRunValue<public>(Player:player):int=
        if (V := RunValueMap[Player]) then V else 0

    ClearRunValue<public>(Player:player):void=
        if (set RunValueMap[Player] = 0) {}

    # --- Estança persistent ---
    GetStashValue<public>(Player:player):int=
        if (D := StashMap[Player]) then D.Value else 0

    # EXTRACCIÓ: passa el botí de la ronda a l'estança i el neteja.
    # Retorna el valor assegurat.
    CommitRun<public>(Player:player):int=
        Earned := GetRunValue(Player)
        Prev := if (D := StashMap[Player]) then D else stash_data{}
        set StashMap[Player] = stash_data:
            Version := Prev.Version
            Value := Prev.Value + Earned
            RunsExtracted := Prev.RunsExtracted + 1
        ClearRunValue(Player)
        Earned

    # Gasta valor de l'estança (loadouts, keycards...). Retorna true si pot pagar.
    SpendStash<public>(Player:player, Cost:int):logic=
        var Ok:logic = false
        if:
            D := StashMap[Player]
            D.Value >= Cost
            set StashMap[Player] = stash_data:
                Version := D.Version
                Value := D.Value - Cost
                RunsExtracted := D.RunsExtracted
            set Ok = true
        Ok

    # Tots els jugadors connectats amb la seva estança, per ordenar el leaderboard.
    GetAllStash<public>(Players:[]player):[]player_and_stash=
        for (Player : Players, D := StashMap[Player]):
            player_and_stash:
                Player := Player
                Stash := D

    # --- Temporada / XP ---
    GrantXP<public>(Player:player, Amount:int, XPPerLevel:int):int=
        Prev := if (D := SeasonMap[Player]) then D else season_data{}
        NewXP := Prev.XP + Amount
        NewLevel := 1 + (NewXP / XPPerLevel)
        set SeasonMap[Player] = season_data:
            Version := Prev.Version
            XP := NewXP
            Level := NewLevel
        NewLevel  # retorna el nou nivell perquè el cridant detecti level-ups

    GetLevel<public>(Player:player):int=
        if (D := SeasonMap[Player]) then D.Level else 1
