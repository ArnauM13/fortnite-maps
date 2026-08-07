using { /Fortnite.com/Devices }
using { /Fortnite.com/Game }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

timer_display := class(creative_device):

    @editable TimerHUD : hud_message_device = hud_message_device{}
    @editable WarningHUD : hud_message_device = hud_message_device{}
    @editable WarningDistance : float = 500.0
    @editable Water : water_controller = water_controller{}

    var IsRunning : logic = false
    var ElapsedSeconds : int = 0
    var IsWarningActive : logic = false

    StartTimer() : void =
        set IsRunning = true
        set ElapsedSeconds = 0
        set IsWarningActive = false
        spawn { TimerLoop() }

    StopTimer() : void =
        set IsRunning = false

    GetElapsedSeconds() : int = ElapsedSeconds

    GetFormattedTime() : string =
        var TotalSec : int = ElapsedSeconds
        var Mins : int = 0
        loop:
            if (TotalSec < 60):
                break
            set TotalSec = TotalSec - 60
            set Mins = Mins + 1
        MinStr : string = if (Mins < 10) then "0{Mins}" else "{Mins}"
        SecStr : string = if (TotalSec < 10) then "0{TotalSec}" else "{TotalSec}"
        "{MinStr}:{SecStr}"

    TimerLoop()<suspends> : void =
        loop:
            if (IsRunning = false):
                break
            Sleep(1.0)
            set ElapsedSeconds = ElapsedSeconds + 1
            TimeStr : string = GetFormattedTime()
            Print("ASCENT | {TimeStr}")

    CheckWaterProximity(PlayerHeight : float) : void =
        WaterHeight : float = Water.GetCurrentHeight()
        Distance : float = PlayerHeight - WaterHeight
        if (Distance <= WarningDistance, IsWarningActive = false):
            set IsWarningActive = true
            Print("AVIS: L'aigua es massa a prop!")
        else if (Distance > WarningDistance, IsWarningActive = true):
            set IsWarningActive = false
            Print("Avis desactivat")
