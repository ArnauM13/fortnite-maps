using { /Fortnite.com/Devices }
using { /Fortnite.com/Characters }
using { /Fortnite.com/Game }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

game_manager := class(creative_device):

    @editable Water : water_controller = water_controller{}
    @editable Checkpoints : checkpoint_tracker = checkpoint_tracker{}
    @editable Timer : timer_display = timer_display{}
    @editable Leaderboard : leaderboard_manager = leaderboard_manager{}
    @editable FinishTrigger : trigger_device = trigger_device{}
    @editable CountdownHUD : hud_message_device = hud_message_device{}
    @editable ProximityCheckInterval : float = 2.0

    var GameState : int = 0

    OnBegin<override>()<suspends> : void =
        Print("ASCENT - Esperant jugadors...")
        set GameState = 0
        Sleep(3.0)
        StartGame()
        race:
            WaitForVictory()
            ProximityCheckLoop()

    StartGame() : void =
        set GameState = 1
        Print("ASCENT - Partida iniciada!")
        Timer.StartTimer()
        Water.StartWaterRise()

    WaitForVictory()<suspends> : void =
        OptAgent := FinishTrigger.TriggeredEvent.Await()
        if (Agent := OptAgent?):
            if (FinishPlayer := player[Agent]):
                OnPlayerFinish(FinishPlayer)

    ProximityCheckLoop()<suspends> : void =
        loop:
            if (GameState <> 1):
                break
            Sleep(ProximityCheckInterval)

    OnPlayerFinish(Player : player)<suspends> : void =
        if (GameState = 1):
            set GameState = 2
            Print("ASCENT - Victoria!")
            Timer.StopTimer()
            Water.StopWaterRise()
            FinalTime : int = Timer.GetElapsedSeconds()
            Leaderboard.SaveScore(FinalTime, Player)
            Sleep(2.0)
            Leaderboard.ShowLeaderboard()
