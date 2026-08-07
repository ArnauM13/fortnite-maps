using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

# Tracks persistable climbing stats for a single player: the highest height
# (in meters) they have ever reached on this island. Saved between sessions
# so the leaderboard survives players leaving and rejoining.
player_climb_stats<public> := class<final><persistable>:
    # Version of this stats table, in case fields need to change later.
    Version<public>:int = 0

    # The highest height (in meters) this player has ever reached.
    BestHeightMeters<public>:int = 0

# Maps each player to their persistable climb stats. Declared once here at
# module level so every device/file in this project shares the same table.
var PlayerClimbStatsMap:weak_map(player, player_climb_stats) = map{}

# Pairs a player with their stats, so both can be passed around and sorted
# together when building the leaderboard.
player_and_climb_stats<public> := struct:
    Player<public>:player
    Stats<public>:player_climb_stats
