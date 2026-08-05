using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

# Displays the top climbers by best height ever reached, on a row of
# Billboard Devices (place them near spawn so players see it before/after
# each run). Assign 3-5 Billboard Devices to Leaderboards below, ordered
# so index 0 is the top rank.
climb_leaderboard := class(creative_device):

    @editable
    Leaderboards:[]billboard_device = array{}

    # How often to refresh the boards, in seconds.
    @editable
    RefreshIntervalSeconds:float = 5.0

    ClimbManager:player_climb_manager = player_climb_manager{}

    RankMessage<localizes>(Rank:int, PlayerName:message, Height:int):message = "#{Rank}  {PlayerName}  -  {Height}m"
    EmptyRankMessage<localizes>(Rank:int):message = "#{Rank}  ---"

    OnBegin<override>()<suspends>:void=
        Players := GetPlayspace().GetPlayers()
        ClimbManager.InitializeAllPlayers(Players)
        loop:
            RefreshLeaderboard(GetPlayspace().GetPlayers())
            Sleep(RefreshIntervalSeconds)

    RefreshLeaderboard(Players:[]player):void=
        ClimbManager.InitializeAllPlayers(Players)
        AllStats := ClimbManager.GetAllPlayerStats(Players)
        Sorted := SortByHeightDescending(AllStats)
        for (Index -> Board : Leaderboards):
            if (Entry := Sorted[Index]):
                Board.SetText(RankMessage(Index + 1, PlayerNameMessage(Entry.Player), Entry.Stats.BestHeightMeters))
            else:
                Board.SetText(EmptyRankMessage(Index + 1))

    PlayerNameMessage<localizes>(Player:player):message = "{Player}"

    # Small insertion sort - there are only ever a handful of players/boards,
    # so this stays fast, simple, and easy to follow without extra libraries.
    SortByHeightDescending(Entries:[]player_and_climb_stats):[]player_and_climb_stats=
        var Sorted:[]player_and_climb_stats = array{}
        for (Entry : Entries):
            set Sorted = InsertSorted(Sorted, Entry)
        Sorted

    InsertSorted(Sorted:[]player_and_climb_stats, NewEntry:player_and_climb_stats):[]player_and_climb_stats=
        var Result:[]player_and_climb_stats = array{}
        var Inserted:logic = false
        for (Existing : Sorted):
            if (not Inserted?, NewEntry.Stats.BestHeightMeters > Existing.Stats.BestHeightMeters):
                set Result += array{NewEntry}
                set Inserted = true
            set Result += array{Existing}
        if (not Inserted?):
            set Result += array{NewEntry}
        Result
