using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/SpatialMath }

# Stateless helper functions for reading and updating each player's RUN stats
# (completion time). Data lives in the shared PlayerRunStatsMap / RunStartMap
# (see climb_run_stats.verse), so any device can create its own
# player_run_manager{} and they all read/write the same records - the same
# pattern as player_climb_manager.verse for heights.
player_run_manager := class():

    # Ensures a player has an entry in the stats table. Safe to call twice.
    InitializePlayer<public>(Player:player):void=
        if:
            not PlayerRunStatsMap[Player]
            set PlayerRunStatsMap[Player] = player_run_stats{}

    InitializeAllPlayers<public>(Players:[]player):void=
        for (Player : Players):
            InitializePlayer(Player)

    # Marks the moment this player's run (re)started.
    StartRun<public>(Player:player):void=
        set RunStartMap[Player] = run_start:
            StartTimeSeconds := GetSimulationElapsedTime()

    # Finishes the run: computes elapsed centiseconds, stores it as a new best
    # if it beats the old record (or if there was none), and returns the time
    # plus whether it was a personal best. Fails if the player never started a
    # run (RunStartMap has no entry).
    FinishRun<public>(Player:player)?:finish_result=
        Start := RunStartMap[Player]
        Stats := PlayerRunStatsMap[Player]
        ElapsedSeconds := GetSimulationElapsedTime() - Start.StartTimeSeconds
        ElapsedCentis := Floor[ElapsedSeconds * 100.0]
        var IsBest:logic = false
        if (Stats.BestTimeCentis = 0):
            set IsBest = true
        else if (ElapsedCentis < Stats.BestTimeCentis):
            set IsBest = true
        if (IsBest?):
            set PlayerRunStatsMap[Player] = player_run_stats:
                Version := Stats.Version
                BestTimeCentis := ElapsedCentis
        finish_result:
            TimeCentis := ElapsedCentis
            IsNewBest := IsBest

    # Returns every currently-connected player who has FINISHED at least once,
    # paired with their stats, for leaderboard sorting.
    GetAllRunStats<public>(Players:[]player):[]player_and_run_stats=
        for:
            Player : Players
            Stats := PlayerRunStatsMap[Player]
            Stats.BestTimeCentis > 0
        do:
            player_and_run_stats:
                Player := Player
                Stats := Stats
