using { /Fortnite.com/Devices }
using { /Fortnite.com/Characters }
using { /Fortnite.com/Game }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

# MissionManager
# Gestiona les missions diàries i l'XP de temporada.
# Dona XP encara que el jugador mori (anti-frustració) i registra el progrés
# persistent per la barra de nivell de temporada.

# Progrés persistent de temporada del jugador
season_progress := class<final><persistable>:
    XP : int = 0
    Level : int = 1

# Mapa persistent de progrés per jugador
var SeasonMap : weak_map(player, season_progress) = map{}

mission_manager := class(creative_device):

    # HUD per notificar missions completades i XP guanyada
    @editable MissionHUD : hud_message_device = hud_message_device{}

    # Leaderboard de valor extret (per ronda o acumulat)
    @editable ValueLeaderboard : leaderboard_device = leaderboard_device{}

    # XP necessària per pujar de nivell
    @editable XPPerLevel : int = 1000

    # --- Recompenses d'XP per acció (veure docs/economy.md) ---
    XP_Extraction : int = 200
    XP_HighValueExtraction : int = 400   # extreu amb 500+ de valor
    XP_EnterVault : int = 250
    XP_Elimination : int = 200

    # Registra una extracció exitosa i atorga XP (+ bonus si és d'alt valor)
    RegisterExtraction(Player : player, ValueExtracted : int) : void =
        GrantXP(Player, XP_Extraction)
        if (ValueExtracted >= 500):
            GrantXP(Player, XP_HighValueExtraction)
            Print("Missió: Extracció d'alt valor! +{XP_HighValueExtraction} XP extra")

        # Registrar el valor al leaderboard
        ValueLeaderboard.SubmitEvent(Player, ValueExtracted)

    # Registra l'entrada a La Bòveda (Zona 3)
    RegisterVaultEntry(Player : player) : void =
        GrantXP(Player, XP_EnterVault)

    # Registra una eliminació PvP
    RegisterElimination(Player : player) : void =
        GrantXP(Player, XP_Elimination)

    # Atorga XP i comprova si el jugador puja de nivell
    GrantXP(Player : player, Amount : int) : void =
        let PrevXP : int = if (P := SeasonMap[Player]) then P.XP else 0
        let PrevLevel : int = if (P := SeasonMap[Player]) then P.Level else 1
        let NewXP : int = PrevXP + Amount
        let NewLevel : int = 1 + (NewXP / XPPerLevel)

        set SeasonMap[Player] = season_progress:
            XP := NewXP
            Level := NewLevel

        Print("Missió: +{Amount} XP (total {NewXP}, nivell {NewLevel})")

        if (NewLevel > PrevLevel):
            OnLevelUp(Player, NewLevel)

    # Executat quan el jugador puja de nivell de temporada
    OnLevelUp(Player : player, NewLevel : int) : void =
        Print("Missió: NIVELL {NewLevel} assolit! Recompensa desbloquejada")
        if (Agent := player[Player]):
            MissionHUD.Show(Agent)

    # Consultes de progrés
    GetXP(Player : player) : int =
        if (P := SeasonMap[Player]):
            return P.XP
        return 0

    GetLevel(Player : player) : int =
        if (P := SeasonMap[Player]):
            return P.Level
        return 1
