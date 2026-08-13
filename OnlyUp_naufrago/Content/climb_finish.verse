using { /Fortnite.com/Devices }
using { /Fortnite.com/Characters }
using { /Fortnite.com/UI }
using { /Verse.org/Simulation }
using { /Verse.org/Colors }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/UI }

# THE FINISH LINE. Place a Trigger Device on the summit platform (the very top
# of the climb) and assign it to FinishTrigger below. When a player walks
# through it their run ENDS: the elapsed time is recorded, a victory banner
# appears, and if it beats their previous best the persistent TIME leaderboard
# (climb_time_leaderboard.verse) updates.
#
# The run clock starts when a player joins / on game start. If you also assign
# a StartTrigger (a plate on the START platform at the bottom), the clock
# (re)starts every time they cross it - this lets players do repeated timed
# attempts without leaving and rejoining.
climb_finish := class(creative_device):

    # Trigger on the summit. Make it wide and flat so players walk through it
    # naturally on arrival - no button press. Unlimited activations, no VFX/SFX.
    @editable
    FinishTrigger:trigger_device = trigger_device{}

    # Optional. Plate at the bottom that (re)starts the run clock when crossed.
    # Leave empty to just start timing at spawn / game start.
    @editable
    StartTrigger:?trigger_device = false

    # Optional. Teleport the finisher to a winner podium / spectator area so
    # the summit doesn't get crowded. Leave empty to leave them on the summit.
    @editable
    WinnerTeleporter:?teleporter_device = false

    # How long the "FINISH!" banner stays on screen, in seconds.
    @editable
    VictoryBannerSeconds:float = 8.0

    RunManager:player_run_manager = player_run_manager{}

    VictoryText<localizes>(Time:string):message = "FINISH!   {Time}"
    VictoryBestText<localizes>(Time:string):message = "FINISH!   {Time}   NEW BEST!"

    OnBegin<override>()<suspends>:void=
        GetPlayspace().PlayerAddedEvent().Subscribe(OnPlayerJoin)
        Players := GetPlayspace().GetPlayers()
        RunManager.InitializeAllPlayers(Players)
        for (Player : Players):
            RunManager.StartRun(Player)
        FinishTrigger.TriggeredEvent.Subscribe(OnPlayerFinished)
        if (Start := StartTrigger?):
            Start.TriggeredEvent.Subscribe(OnPlayerStarted)

    OnPlayerJoin(Agent:agent):void=
        if (Player := player[Agent]):
            RunManager.InitializePlayer(Player)
            RunManager.StartRun(Player)

    OnPlayerStarted(MaybeAgent:?agent):void=
        if (Agent := MaybeAgent?, Player := player[Agent]):
            RunManager.StartRun(Player)

    OnPlayerFinished(MaybeAgent:?agent):void=
        if:
            Agent := MaybeAgent?
            Player := player[Agent]
            Result := RunManager.FinishRun[Player]
        then:
            spawn:
                ShowVictoryBanner(Player, Result)
            if (Tp := WinnerTeleporter?):
                Tp.Teleport(Agent)
        else:
            Print("Finish trigger fired without a valid/started player")

    ShowVictoryBanner(Player:player, Result:finish_result)<suspends>:void=
        TimeStr := TimeString(Result.TimeCentis)
        TextWidget:text_block = text_block{DefaultTextColor := NamedColors.White}
        if (Result.IsNewBest?):
            TextWidget.SetText(VictoryBestText(TimeStr))
        else:
            TextWidget.SetText(VictoryText(TimeStr))
        NewCanvas:canvas = canvas:
            Slots := array:
                canvas_slot:
                    Widget := TextWidget
                    Anchors := anchors{ Minimum := vector2{ X := 0.5, Y := 0.35}, Maximum := vector2{ X := 0.5, Y := 0.35}}
        if (PlayerUI := GetPlayerUI[Player]):
            PlayerUI.AddWidget(NewCanvas)
            Sleep(VictoryBannerSeconds)
            PlayerUI.RemoveWidget(NewCanvas)
