using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

# Displays the FASTEST completion times, on a row of Billboard Devices (place
# them near spawn / the start platform so players see the target time before a
# run and the results after). Assign 3-5 Billboard Devices to Leaderboards
# below, ordered so index 0 is the fastest rank. Only players who have
# actually crossed the finish appear here.
#
# Twin of climb_leaderboard.verse (best HEIGHT), but sorted ASCENDING so the
# lowest time wins.
climb_time_leaderboard := class(creative_device):

    @editable
    Leaderboards:[]billboard_device = array{}

    # How often to refresh the boards, in seconds.
    @editable
    RefreshIntervalSeconds:float = 5.0

    RunManager:player_run_manager = player_run_manager{}

    RankMessage<localizes>(Rank:int, Climber:agent, Time:string):message = "#{Rank}  {Climber}  -  {Time}"
    EmptyRankMessage<localizes>(Rank:int):message = "#{Rank}  ---"

    OnBegin<override>()<suspends>:void=
        RunManager.InitializeAllPlayers(GetPlayspace().GetPlayers())
        loop:
            RefreshLeaderboard(GetPlayspace().GetPlayers())
            Sleep(RefreshIntervalSeconds)

    RefreshLeaderboard(Players:[]player):void=
        RunManager.InitializeAllPlayers(Players)
        AllStats := RunManager.GetAllRunStats(Players)
        Sorted := SortByTimeAscending(AllStats)
        for (Index -> Board : Leaderboards):
            if (Entry := Sorted[Index]):
                Board.SetText(RankMessage(Index + 1, Entry.Player, TimeString(Entry.Stats.BestTimeCentis)))
            else:
                Board.SetText(EmptyRankMessage(Index + 1))

    # Small insertion sort - only ever a handful of players/boards, so this
    # stays fast and easy to follow without extra libraries.
    SortByTimeAscending(Entries:[]player_and_run_stats):[]player_and_run_stats=
        var Sorted:[]player_and_run_stats = array{}
        for (Entry : Entries):
            set Sorted = InsertSorted(Sorted, Entry)
        Sorted

    InsertSorted(Sorted:[]player_and_run_stats, NewEntry:player_and_run_stats):[]player_and_run_stats=
        var Result:[]player_and_run_stats = array{}
        var Inserted:logic = false
        for (Existing : Sorted):
            if (not Inserted?, NewEntry.Stats.BestTimeCentis < Existing.Stats.BestTimeCentis):
                set Result += array{NewEntry}
                set Inserted = true
            set Result += array{Existing}
        if (not Inserted?):
            set Result += array{NewEntry}
        Result
