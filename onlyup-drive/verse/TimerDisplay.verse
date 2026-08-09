using { /Fortnite.com/Devices }
using { /Fortnite.com/Characters }
using { /Fortnite.com/Game }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

# Timer de la partida per al leaderboard de temps (contrarellotge fins al cim).
timer_display := class(creative_device):

    @editable HUD : hud_message_device = hud_message_device{}
    @editable TickInterval : float = 1.0

    var ElapsedSeconds : int = 0
    var Running : logic = false

    OnBegin<override>()<suspends> : void =
        loop:
            Sleep(TickInterval)
            if (Running?):
                set ElapsedSeconds = ElapsedSeconds + 1

    StartTimer() : void =
        set ElapsedSeconds = 0
        set Running = true
        Print("Timer iniciat.")

    StopTimer() : void =
        set Running = false
        Print("Timer aturat a {ElapsedSeconds}s.")

    GetElapsedSeconds() : int = ElapsedSeconds

    # Format MM:SS per mostrar (helper).
    FormatTime() : string =
        Minutes := ElapsedSeconds / 60
        Seconds := Mod[ElapsedSeconds, 60]
        return "{Minutes}:{Seconds}"
