using { /Fortnite.com/Devices }
using { /Fortnite.com/Characters }
using { /Fortnite.com/Game }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

# GameManager
# Orquestra tots els sistemes de la partida ASCENT.
# Estats: Waiting → Playing → Finished
# Gestiona inici, victòria i comprovació de proximitat de l'aigua.

game_manager := class(creative_device):

    # --- Referències als altres sistemes (assignar al UEFN editor) ---
    @editable Water : water_controller = water_controller{}
    @editable Checkpoints : checkpoint_tracker = checkpoint_tracker{}
    @editable Timer : timer_display = timer_display{}
    @editable Leaderboard : leaderboard_manager = leaderboard_manager{}

    # Trigger col·locat a la plataforma de victòria (Zona 5 — Cim)
    @editable FinishTrigger : trigger_device = trigger_device{}

    # HUD de compte enrere abans d'iniciar (opcional)
    @editable CountdownHUD : hud_message_device = hud_message_device{}

    # Interval en segons per comprovar proximitat de l'aigua
    @editable ProximityCheckInterval : float = 2.0

    # --- Estat intern ---
    var GameState : int = 0  # 0=Waiting, 1=Playing, 2=Finished

    OnBegin<override>()<suspends> : void =
        Print("ASCENT — Esperant jugadors...")
        set GameState = 0

        # Petit compte enrere abans d'iniciar
        Sleep(3.0)

        StartGame()

        # Esperar victòria en paral·lel amb la comprovació de proximitat
        race:
            WaitForVictory()
            ProximityCheckLoop()

    # Inicia tots els sistemes alhora
    StartGame() : void =
        set GameState = 1
        Print("ASCENT — Partida iniciada!")
        Timer.StartTimer()
        Water.StartWaterRise()

    # Espera que el jugador activi el trigger del cim
    WaitForVictory()<suspends> : void =
        let Payload := FinishTrigger.TriggeredEvent.Await()
        if (Agent := Payload.Agent?):
            if (FinishPlayer := player[Agent]):
                OnPlayerFinish(FinishPlayer)

    # Comprova cada N segons si l'aigua és massa a prop del jugador
    ProximityCheckLoop()<suspends> : void =
        loop:
            if (GameState <> 1):
                break
            Sleep(ProximityCheckInterval)
            # TODO: obtenir alçada del jugador via fort_character.GetTransform()
            # i passar-la a Timer.CheckWaterProximity(PlayerHeight)

    # Executat quan un jugador arriba al cim
    OnPlayerFinish(Player : player) : void =
        if (GameState = 1):
            set GameState = 2
            Print("ASCENT — Victòria!")

            Timer.StopTimer()
            Water.StopWaterRise()

            let FinalTime : int = Timer.GetElapsedSeconds()
            Leaderboard.SaveScore(FinalTime, Player)

            Sleep(2.0)
            Leaderboard.ShowLeaderboard()
