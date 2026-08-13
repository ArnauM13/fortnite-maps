using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

# Persistable "best time" for a single player: the fastest they have ever
# reached the finish, stored in centiseconds (hundredths of a second) as an
# int so it persists cleanly and sorts trivially. 0 means "never finished".
#
# Mirrors player_climb_stats.verse (best HEIGHT) so both leaderboards behave
# and persist identically once island persistence is enabled.
player_run_stats<public> := class<final><persistable>:
    # Version of this stats table, in case fields need to change later.
    Version<public>:int = 0

    # Fastest completion time ever, in centiseconds. 0 = no finish recorded.
    BestTimeCentis<public>:int = 0

# Maps each player to their persistable run stats. Declared once here at
# module level so every device/file shares the same table.
var PlayerRunStatsMap:weak_map(player, player_run_stats) = map{}

# When the player's CURRENT run started, in seconds of simulation time.
# Session-only (overwritten every time a run starts), wrapped in a class so
# it slots into a module-scope weak_map like the other shared state.
run_start<public> := class<final><persistable>:
    StartTimeSeconds<public>:float = 0.0

var RunStartMap:weak_map(player, run_start) = map{}

# Pairs a player with their run stats so both can be sorted together when
# building the time leaderboard.
player_and_run_stats<public> := struct:
    Player<public>:player
    Stats<public>:player_run_stats

# The outcome of finishing a run: how long it took and whether it beat the
# player's previous best.
finish_result<public> := struct:
    TimeCentis<public>:int
    IsNewBest<public>:logic

# Formats a centisecond count as "M:SS.CS" (e.g. 1:23.45). Uses integer
# division only, exactly like RaidTimer.GetFormattedRemaining in this repo.
TimeString<public>(Centis:int):string=
    TotalSeconds := Centis / 100
    Minutes := TotalSeconds / 60
    Seconds := TotalSeconds - Minutes * 60
    Hundredths := Centis - TotalSeconds * 100
    SecStr := if (Seconds < 10) then "0{Seconds}" else "{Seconds}"
    CsStr := if (Hundredths < 10) then "0{Hundredths}" else "{Hundredths}"
    "{Minutes}:{SecStr}.{CsStr}"
