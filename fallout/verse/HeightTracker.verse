using { /Fortnite.com/Devices }
using { /Fortnite.com/Characters }
using { /Fortnite.com/Playspaces }
using { /Verse.org/Simulation }
using { /Verse.org/Simulation/Tags }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/SpatialMath }

# HeightTracker
# El cor del joc estil Only Up: mesura contínuament l'alçada de cada jugador,
# la converteix a metres i manté la seva MILLOR marca. Actualitza el HUD i
# alimenta el leaderboard.
#
# No hi ha checkpoints: aquest sistema no "guarda" cap posició, només observa.
# Guardem la millor alçada (no l'actual) perquè caure no ha de baixar el rècord.

height_tracker := class(creative_device):

    # Alçada (Z) del terra d'inici, en unitats Unreal. Tot es mesura respecte
    # d'aquí. Assignar a l'editor col·locant un marcador al fons del Vault.
    @editable StartHeightZ : float = 0.0

    # HUD que mostra l'alçada actual i la millor marca del jugador.
    @editable HeightHUD : hud_message_device = hud_message_device{}

    # Cada quant (segons) es refresca la lectura d'alçada.
    @editable TickInterval : float = 0.25

    # Millor alçada (en metres) assolida per cada jugador durant la partida.
    var BestHeights : [player]float = map{}

    # Arrenca el seguiment per a tots els jugadors presents.
    Start()<suspends> : void =
        Print("HeightTracker — seguiment d'alçada iniciat")
        loop:
            Sleep(TickInterval)
            for (Player : GetPlayspace().GetPlayers()):
                UpdatePlayer(Player)

    # Llegeix l'alçada d'un jugador i actualitza la seva millor marca + HUD.
    UpdatePlayer(Player : player) : void =
        if (Character := Player.GetFortCharacter[]):
            let CurrentZ : float = Character.GetTransform().Translation.Z
            let CurrentMeters : float = (CurrentZ - StartHeightZ) / 100.0

            # Actualitza el rècord només si supera l'anterior.
            var Best : float = 0.0
            if (Stored := BestHeights[Player]):
                set Best = Stored
            if (CurrentMeters > Best):
                set Best = CurrentMeters
                if (set BestHeights[Player] = Best) {}
                OnNewBest(Player)

            ShowHeight(Player, CurrentMeters, Best)

    # Refresca el HUD del jugador amb l'alçada actual i la millor marca.
    ShowHeight(Player : player, Current : float, Best : float) : void =
        let CurrentM : int = Round[Current] or 0
        let BestM : int = Round[Best] or 0
        # TODO (wiring UEFN): mostrar només a aquest jugador amb HeightHUD.
        # Format objectiu:  "{CurrentM} m"  amb subtítol  "MILLOR: {BestM} m"
        Print("Alçada: {CurrentM} m (millor: {BestM} m)")

    # Feedback en superar la teva millor marca (so/VFX es connecten a l'editor).
    OnNewBest(Player : player) : void =
        # TODO: reproduir so/VFX de "nou rècord" via un device assignable.
        Print("Nou rècord d'alçada!")

    # Consulta la millor alçada d'un jugador (la fa servir el LeaderboardManager).
    GetBestHeight(Player : player) : float =
        if (Best := BestHeights[Player]):
            return Best
        return 0.0
