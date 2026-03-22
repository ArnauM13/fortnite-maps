using { /Fortnite.com/Devices }
using { /Fortnite.com/Characters }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

# LeaderboardManager — Guarda i mostra els millors temps
# Integra amb el leaderboard_device de UEFN

leaderboard_manager := class(creative_device):

    # Dispositiu de leaderboard de UEFN
    @editable Leaderboard : leaderboard_device = leaderboard_device{}

    # Guarda la puntuació d'un jugador (temps en segons)
    # Menys temps = millor puntuació → guardem com a negatiu
    SaveScore(TimeInSeconds : int) : void =
        Print("Leaderboard: Guardant temps de {TimeInSeconds} segons")
        # TODO: obtenir el jugador actual i cridar Leaderboard.SetScoreForPlayer()
        # Leaderboard.SetScoreForPlayer(Player, float(TimeInSeconds * -1), false)
