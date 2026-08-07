using { /Fortnite.com/Devices }
using { /Fortnite.com/Characters }
using { /Fortnite.com/Game }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

# InventoryManager
# Capa fina sobre l'estat compartit (shared_state.verse). Gestiona les dues
# capes de botí del jugador:
#   - Ronda actual (RunValue): es perd si mors.
#   - Estança (Stash): persistent, mai es perd.
#
# Tota la lògica de dades viu a 'extraction_state' (patró calcat de
# player_climb_manager.verse del Naufragi), així que aquest device només
# exposa mètodes convenients per a la resta del joc.

inventory_manager := class(creative_device):

    # HUD que mostra el valor actual (ronda + estança) en fites puntuals.
    @editable ValueHUD : hud_message_device = hud_message_device{}

    # Helper compartit — llegeix/escriu les mateixes taules de mòdul que la resta.
    State : extraction_state = extraction_state{}

    OnBegin<override>()<suspends>:void=
        # Inicialitzar tots els jugadors presents i els que s'uneixin després.
        State.InitializeAll(GetPlayspace().GetPlayers())
        GetPlayspace().PlayerAddedEvent().Subscribe(OnPlayerJoin)

    OnPlayerJoin(Agent:agent):void=
        if (Player := player[Agent]):
            State.InitializePlayer(Player)

    # Recollir un objecte durant la ronda
    AddRunLoot(Player : player, Amount : int) : void =
        State.AddRunValue(Player, Amount)
        Print("Inventari: +{Amount} valor de ronda (total: {State.GetRunValue(Player)})")

    GetRunLoot(Player : player) : int = State.GetRunValue(Player)
    GetStashValue(Player : player) : int = State.GetStashValue(Player)

    # EXTRACCIÓ EXITOSA: el botí de ronda passa a l'estança. Retorna el valor assegurat.
    CommitRunLoot(Player : player) : int =
        Earned := State.CommitRun(Player)
        Print("Inventari: {Earned} valor assegurat (estança: {State.GetStashValue(Player)})")
        Earned

    # MORT: es perd el botí de la ronda; l'estança es conserva.
    LoseRunLoot(Player : player) : void =
        Lost := State.GetRunValue(Player)
        State.ClearRunValue(Player)
        Print("Inventari: {Lost} valor PERDUT per mort (estança intacta)")

    CanAfford(Player : player, Cost : int) : logic = State.GetStashValue(Player) >= Cost

    SpendStash(Player : player, Cost : int) : logic = State.SpendStash(Player, Cost)
