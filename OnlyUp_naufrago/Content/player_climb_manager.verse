using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

# Stateless helper functions for reading and updating each player's climb
# stats. Actual data lives in the shared PlayerClimbStatsMap (see
# player_climb_stats.verse), so any device can create its own
# player_climb_manager{} and they will all read/write the same records.
player_climb_manager := class():

    # Ensures a player has an entry in the stats table. Safe to call more than once.
    InitializePlayer<public>(Player:player):void=
        if:
            not PlayerClimbStatsMap[Player]
            set PlayerClimbStatsMap[Player] = player_climb_stats{}
        else:
            Print("Climb stats already initialized for player")

    InitializeAllPlayers<public>(Players:[]player):void=
        for (Player : Players):
            InitializePlayer(Player)

    # Updates the player's best height only if the new height beats their
    # current record. Returns true if this was a new personal best.
    ReportHeight<public>(Agent:agent, HeightMeters:int):logic=
        var IsNewBest:logic = false
        if:
            Player := player[Agent]
            CurrentStats := PlayerClimbStatsMap[Player]
            HeightMeters > CurrentStats.BestHeightMeters
            set PlayerClimbStatsMap[Player] = player_climb_stats:
                Version := CurrentStats.Version
                BestHeightMeters := HeightMeters
            set IsNewBest = true
        IsNewBest

    # Returns every currently-connected player paired with their stats, for
    # leaderboard sorting. Players with no recorded stats yet are skipped.
    GetAllPlayerStats<public>(Players:[]player):[]player_and_climb_stats=
        for (Player : Players, CurrentStats := PlayerClimbStatsMap[Player]):
            player_and_climb_stats:
                Player := Player
                Stats := CurrentStats
