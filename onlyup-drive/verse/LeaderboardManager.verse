using { /Fortnite.com/Devices }
using { /Fortnite.com/Characters }
using { /Fortnite.com/Game }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

# Dos rànquings: millor temps al cim i alçada màxima assolida.
leaderboard_manager := class(creative_device):

    @editable TimeLeaderboard : billboard_device = billboard_device{}
    @editable HeightLeaderboard : billboard_device = billboard_device{}
    @editable TimeTracker : score_manager_device = score_manager_device{}
    @editable HeightTracker : score_manager_device = score_manager_device{}

    SaveTime(Seconds : int, Player : player) : void =
        # Menys temps = millor. La configuració del score_manager pot invertir l'ordre.
        TimeTracker.SetScoreAward(Seconds)
        TimeTracker.Activate(Player)
        Print("Temps desat: {Seconds}s")

    SaveHeight(Height : int, Player : player) : void =
        HeightTracker.SetScoreAward(Height)
        HeightTracker.Activate(Player)
        Print("Alçada desada: {Height}m")

    ShowLeaderboard() : void =
        Print("Mostrant rànquings (temps + alçada).")
