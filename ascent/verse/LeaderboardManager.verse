using { /Fortnite.com/Devices }
using { /Fortnite.com/Characters }
using { /Fortnite.com/Game }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

# LeaderboardManager
# Guarda el temps final de cada jugador al leaderboard de UEFN.
# Menys temps = millor resultat, per això es guarda com a valor negatiu.

leaderboard_manager := class(creative_device):

    # Dispositiu de leaderboard de UEFN (assignar al editor)
    @editable Leaderboard : leaderboard_device = leaderboard_device{}

    # HUD per mostrar el temps final en pantalla al acabar
    @editable FinishHUD : hud_message_device = hud_message_device{}

    # Guarda la puntuació d'un jugador quan acaba la partida
    # TimeInSeconds: temps total de la partida
    # Player: el jugador que ha acabat
    SaveScore(TimeInSeconds : int, Player : player) : void =
        Print("Leaderboard: Guardant temps {TimeInSeconds}s per jugador")

        # Guardar al leaderboard: negatiu perquè menys temps = millor posició
        let Score : float = float(TimeInSeconds) * -1.0
        Leaderboard.SetScoreForPlayer(Player, Score, false)

        # Mostrar missatge de felicitació amb el temps
        let Minutes : int = TimeInSeconds / 60
        let Seconds : int = TimeInSeconds - (Minutes * 60)
        let MinStr : string = if (Minutes < 10) then "0{Minutes}" else "{Minutes}"
        let SecStr : string = if (Seconds < 10) then "0{Seconds}" else "{Seconds}"
        Print("Has completat ASCENT en {MinStr}:{SecStr}!")

    # Mostra el leaderboard a tots els jugadors (cridat en acabar)
    ShowLeaderboard() : void =
        Leaderboard.Show()
