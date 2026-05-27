using { /Fortnite.com/Devices }
using { /Fortnite.com/Characters }
using { /Fortnite.com/Game }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

# Guarda la puntuació de cada jugador al leaderboard de UEFN i mostra el resultat final.
# Puntuació = temps en ms negatiu (menys temps = puntuació més alta = millor posició).

leaderboard_manager := class(creative_device):

    # Dispositiu leaderboard de UEFN (configurar al editor)
    @editable Leaderboard : leaderboard_device = leaderboard_device{}

    # HUD de victòria — configurat al editor amb text de felicitació
    # (es mostra individualment a cada jugador quan acaba)
    @editable VictoryHUD : hud_message_device = hud_message_device{}

    # Temps en segons de pausa entre el missatge de victòria i el leaderboard
    @editable LeaderboardDelay : float = 3.0

    # Guarda la puntuació i mostra el resultat al jugador que ha acabat
    SaveScore(TimeInSeconds : int, Player : player)<suspends> : void =
        let Score : float = float(TimeInSeconds) * -1.0
        Leaderboard.SetScoreForPlayer(Player, Score, false)

        let TimeStr : string = FormatTime(TimeInSeconds)
        Print("[LB] Temps final: {TimeStr} — score: {Score}")

        VictoryHUD.Show(Player)

        Sleep(LeaderboardDelay)
        Leaderboard.Show()

    # Mostra el leaderboard a tots (cridat si tots els jugadors han acabat)
    ShowLeaderboard() : void =
        Leaderboard.Show()

    FormatTime(TotalSeconds : int) : string =
        let M : int = TotalSeconds / 60
        let S : int = TotalSeconds - (M * 60)
        let MinStr : string = if (M < 10) then "0{M}" else "{M}"
        let SecStr : string = if (S < 10) then "0{S}" else "{S}"
        "{MinStr}:{SecStr}"
