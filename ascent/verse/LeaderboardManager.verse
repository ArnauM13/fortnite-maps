using { /Fortnite.com/Devices }
using { /Fortnite.com/Characters }
using { /Fortnite.com/Game }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

leaderboard_manager := class(creative_device):

    @editable FinishHUD : hud_message_device = hud_message_device{}

    SaveScore(TimeInSeconds : int, Player : player) : void =
        var TotalSec : int = TimeInSeconds
        var Mins : int = 0
        loop:
            if (TotalSec < 60):
                break
            set TotalSec = TotalSec - 60
            set Mins = Mins + 1
        Print("ASCENT completat en {Mins}m {TotalSec}s!")
        FinishHUD.Show(Player)

    ShowLeaderboard() : void =
        Print("Partida finalitzada!")
