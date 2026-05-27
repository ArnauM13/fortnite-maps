using { /Fortnite.com/Devices }
using { /Fortnite.com/Characters }
using { /Fortnite.com/Game }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

# Orquestra tots els sistemes de ASCENT.
# Estats: 0=Waiting, 1=Playing, 2=Finished
# Suporta 1–4 jugadors (race mode: cadascú té el seu temps).

game_manager := class(creative_device):

    @editable Water : water_controller = water_controller{}
    @editable Checkpoints : checkpoint_tracker = checkpoint_tracker{}
    @editable Timer : timer_display = timer_display{}
    @editable Leaderboard : leaderboard_manager = leaderboard_manager{}

    # Trigger col·locat a la plataforma de victòria (Zona 5)
    @editable FinishTrigger : trigger_device = trigger_device{}

    # HUD visible durant l'espera, tapat quan comença la partida
    @editable WaitingHUD : hud_message_device = hud_message_device{}

    # Temps en segons d'espera abans d'iniciar (compte enrere)
    @editable PreGameDelay : float = 5.0

    # Interval en segons per comprovar proximitat de l'aigua
    @editable ProximityCheckInterval : float = 1.5

    var GameState : int = 0
    var FinishedPlayers : int = 0

    OnBegin<override>()<suspends> : void =
        Print("[GM] ASCENT inicialitzat — esperant {PreGameDelay}s")
        WaitingHUD.ShowAllPlayers()
        Sleep(PreGameDelay)
        WaitingHUD.HideAllPlayers()

        StartGame()

        race:
            ListenForFinish()
            ProximityCheckLoop()

    StartGame() : void =
        set GameState = 1
        set FinishedPlayers = 0
        Print("[GM] Partida iniciada!")
        Timer.StartTimer()
        Water.StartWaterRise()

    # Escolta el trigger de victòria en bucle (suport per múltiples jugadors)
    ListenForFinish()<suspends> : void =
        loop:
            let Payload := FinishTrigger.TriggeredEvent.Await()
            if (GameState = 1):
                if (Agent := Payload.Agent?):
                    if (FinishPlayer := player[Agent]):
                        spawn { HandlePlayerFinish(FinishPlayer) }

    # Gestiona la victòria d'un jugador concret
    HandlePlayerFinish(Player : player)<suspends> : void =
        set FinishedPlayers = FinishedPlayers + 1
        let FinalTime : int = Timer.GetElapsedSeconds()
        Print("[GM] Jugador acabat — {Timer.GetFormattedTime()} (#{FinishedPlayers})")

        # Si és el primer en acabar, atura l'aigua i el timer
        if (FinishedPlayers = 1):
            set GameState = 2
            Timer.StopTimer()
            Water.StopWaterRise()

        Leaderboard.SaveScore(FinalTime, Player)

    # Comprova cada ProximityCheckInterval si l'aigua és massa a prop dels jugadors
    ProximityCheckLoop()<suspends> : void =
        loop:
            if (GameState <> 1):
                break
            Sleep(ProximityCheckInterval)

            let Players : []player = GetPlayspace().GetPlayers()
            for (Player : Players):
                if (Character := Player.GetFortCharacter[]):
                    let PlayerPos : vector3 = Character.GetTransform().Translation
                    Timer.CheckWaterProximity(PlayerPos.Z, Player)
