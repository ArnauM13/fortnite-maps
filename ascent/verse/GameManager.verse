using { /Fortnite.com/Devices }
using { /Fortnite.com/Characters }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

# GameManager — Controla l'estat global de la partida ASCENT
# S'encarrega d'iniciar el joc, gestionar zones i detectar victòria

game_manager := class(creative_device):

    # Referència al controlador d'aigua
    @editable WaterController : water_controller = water_controller{}

    # Referència al tracker de checkpoints
    @editable CheckpointTracker : checkpoint_tracker = checkpoint_tracker{}

    # Referència al display del timer
    @editable TimerDisplay : timer_display = timer_display{}

    # Referència al leaderboard
    @editable LeaderboardManager : leaderboard_manager = leaderboard_manager{}

    # Dispositiu de la plataforma de victòria (zona 5, cim)
    @editable FinishPlatform : trigger_device = trigger_device{}

    # S'executa quan comença la partida
    OnBegin<override>()<suspends> : void =
        Print("ASCENT — Partida iniciada")

        # Iniciar el timer
        TimerDisplay.StartTimer()

        # Iniciar la pujada d'aigua
        WaterController.StartWaterRise()

        # Esperar que un jugador arribi al cim
        FinishPlatform.TriggeredEvent.Await()

        # Aturar tot quan acaba
        OnPlayerFinish()

    # Quan un jugador arriba al cim
    OnPlayerFinish() : void =
        Print("ASCENT — Jugador ha arribat al cim!")
        TimerDisplay.StopTimer()
        WaterController.StopWaterRise()
        LeaderboardManager.SaveScore(TimerDisplay.GetElapsedTime())
