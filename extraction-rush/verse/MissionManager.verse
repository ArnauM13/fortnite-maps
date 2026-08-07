using { /Fortnite.com/Devices }
using { /Fortnite.com/Characters }
using { /Fortnite.com/Game }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

# MissionManager
# Missions diàries i XP de temporada. El progrés persistent viu a l'estat
# compartit (season_data / SeasonMap a shared_state.verse), gestionat amb el
# mateix patró que les estadístiques del Naufragi. Dona XP encara que el
# jugador mori (anti-frustració).

mission_manager := class(creative_device):

    # HUD per notificar missions completades i pujades de nivell.
    @editable MissionHUD : hud_message_device = hud_message_device{}

    # Leaderboard natiu de UEFN per al valor extret per ronda (opcional;
    # el rànquing persistent d'estança es mostra amb extraction_leaderboard.verse).
    @editable ValueLeaderboard : leaderboard_device = leaderboard_device{}

    # XP necessària per pujar de nivell.
    @editable XPPerLevel : int = 1000

    # Helper compartit sobre les taules de mòdul.
    State : extraction_state = extraction_state{}

    # --- Recompenses d'XP per acció (veure docs/economy.md) ---
    XP_Extraction : int = 200
    XP_HighValueExtraction : int = 400   # extreu amb 500+ de valor
    XP_EnterVault : int = 250
    XP_Elimination : int = 200

    OnBegin<override>()<suspends>:void=
        State.InitializeAll(GetPlayspace().GetPlayers())
        GetPlayspace().PlayerAddedEvent().Subscribe(OnPlayerJoin)

    OnPlayerJoin(Agent:agent):void=
        if (Player := player[Agent]):
            State.InitializePlayer(Player)

    # Extracció exitosa → XP base (+ bonus si és d'alt valor) i registre al leaderboard.
    RegisterExtraction(Player : player, ValueExtracted : int) : void =
        GrantXP(Player, XP_Extraction)
        if (ValueExtracted >= 500):
            GrantXP(Player, XP_HighValueExtraction)
            Print("Missió: Extracció d'alt valor! +{XP_HighValueExtraction} XP extra")
        ValueLeaderboard.SubmitEvent(Player, ValueExtracted)

    RegisterVaultEntry(Player : player) : void = GrantXP(Player, XP_EnterVault)
    RegisterElimination(Player : player) : void = GrantXP(Player, XP_Elimination)

    # Atorga XP via l'estat compartit i detecta pujada de nivell.
    GrantXP(Player : player, Amount : int) : void =
        PrevLevel := State.GetLevel(Player)
        NewLevel := State.GrantXP(Player, Amount, XPPerLevel)
        Print("Missió: +{Amount} XP (nivell {NewLevel})")
        if (NewLevel > PrevLevel):
            OnLevelUp(Player, NewLevel)

    OnLevelUp(Player : player, NewLevel : int) : void =
        Print("Missió: NIVELL {NewLevel} assolit! Recompensa desbloquejada")
        MissionHUD.Show(Player)

    GetLevel(Player : player) : int = State.GetLevel(Player)
