using { /Fortnite.com/Devices }
using { /Fortnite.com/Characters }
using { /Fortnite.com/Game }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

# LEADERBOARD EN PANTALLA (HUD viu, no cartelera física).
# Mostra a cada jugador el rànquing d'alçada en directe durant l'escalada:
# top-3 + la teva posició. S'actualitza cada pocs segons.
# Complementa leaderboard_manager (que són les carteleres físiques de rècords).
live_leaderboard_hud := class(creative_device):

    @editable Heights : height_tracker = height_tracker{}
    # Un hud_message per línia visible (p. ex. 4: top-3 + "tu"). Ancorats a pantalla.
    @editable Line1 : hud_message_device = hud_message_device{}
    @editable Line2 : hud_message_device = hud_message_device{}
    @editable Line3 : hud_message_device = hud_message_device{}
    @editable YourLine : hud_message_device = hud_message_device{}
    @editable RefreshSeconds : float = 3.0

    OnBegin<override>()<suspends> : void =
        loop:
            Sleep(RefreshSeconds)
            Refresh()

    Refresh() : void =
        # A UEFN: ordena els jugadors per alçada actual i actualitza el text.
        # Aquí deixem l'estructura; el text real es compon amb GetPlayers +
        # l'alçada de cada un (via height_tracker) i es passa a cada hud_message.
        Players := GetPlayspace().GetPlayers()
        for (P : Players):
            # Mostra el HUD a cada jugador (el text/ordre es calcula a UEFN).
            Line1.Show(P)
            Line2.Show(P)
            Line3.Show(P)
            YourLine.Show(P)
        Print("Live HUD refrescat ({RefreshSeconds}s)")
