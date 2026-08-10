using { /Fortnite.com/Devices }
using { /Fortnite.com/Characters }
using { /Fortnite.com/Game }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

# ONLY UP: DRIVE — Orquestrador principal.
# Estats: 0 = esperant, 1 = escalant, 2 = algú al cim.
game_manager := class(creative_device):

    @editable Heights : height_tracker = height_tracker{}
    @editable Checkpoints : checkpoint_manager = checkpoint_manager{}
    @editable Coins : coin_manager = coin_manager{}
    @editable FallReset : fall_reset_manager = fall_reset_manager{}
    @editable Timer : timer_display = timer_display{}
    @editable Leaderboard : leaderboard_manager = leaderboard_manager{}
    @editable Meta : meta_progress = meta_progress{}
    @editable Daily : daily_challenge_manager = daily_challenge_manager{}
    @editable FinishTrigger : trigger_device = trigger_device{}
    @editable WelcomeHUD : hud_message_device = hud_message_device{}
    @editable StartDelay : float = 2.0
    @editable TotalCoinsInMap : int = 63

    var GameState : int = 0

    OnBegin<override>()<suspends> : void =
        Print("ONLY UP: DRIVE — carregant autopista...")
        set GameState = 0
        Sleep(StartDelay)
        StartClimb()
        WaitForSummit()

    StartClimb() : void =
        set GameState = 1
        Print("ONLY UP: DRIVE — amunt!")
        Timer.StartTimer()
        # Els altres sistemes (alçada, monedes, checkpoints, reset)
        # ja escolten pel seu compte des dels seus OnBegin.

    WaitForSummit()<suspends> : void =
        loop:
            OptAgent := FinishTrigger.TriggeredEvent.Await()
            if (Agent := OptAgent?, Player := player[Agent]):
                OnPlayerSummit(Player)

    OnPlayerSummit(Player : player)<suspends> : void =
        Print("ONLY UP: DRIVE — algú ha arribat al Cim del Sol!")
        FinalTime : int = Timer.GetElapsedSeconds()
        FinalHeight : int = Heights.GetBestHeight()
        Leaderboard.SaveTime(FinalTime, Player)
        Leaderboard.SaveHeight(FinalHeight, Player)

        # Meta-progressió persistent (KM) i reptes diaris.
        BoughtCP := Checkpoints.GetPurchased(Player) >= 0
        AllCoins := Coins.GetBalance(Player) >= TotalCoinsInMap
        Meta.AwardEndOfRun(Player, FinalHeight, true, BoughtCP, AllCoins, FinalTime)
        if (not BoughtCP?):
            Daily.ReportProgress(Player, challenge_kind.PureClear, 1)
        Daily.ReportProgress(Player, challenge_kind.SpeedClear, FinalTime)

        if (GameState < 2):
            set GameState = 2
        Sleep(2.0)
        Leaderboard.ShowLeaderboard()

    GetGameState() : int = GameState
