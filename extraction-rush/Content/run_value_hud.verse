using { /Fortnite.com/Devices }
using { /Fortnite.com/Characters }
using { /Fortnite.com/UI }
using { /Verse.org/Simulation }
using { /Verse.org/Colors }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/UI }

# run_value_hud
# Adaptació de 'distant_device.verse' (OnlyUp Naufragi): en comptes de mostrar
# l'alçada en metres, mostra en pantalla i en temps real el VALOR 💠 que el
# jugador porta a sobre en la ronda actual — el que perdria si mor. És el
# recordatori constant de "risc" que fa funcionar l'extraction shooter.

run_value_hud := class(creative_device):

    # Helper compartit per llegir el valor de ronda de cada jugador.
    State:extraction_state = extraction_state{}

    ValueText<localizes>(Value : int) : message = "En risc:  {Value} 💠"

    (Player : player).InitUI() : void =
        TextWidget : text_block = text_block{DefaultTextColor := NamedColors.White}
        NewCanvas : canvas = canvas:
            Slots := array:
                canvas_slot:
                    Widget := TextWidget
                    # A dalt centrat, sota el minimap.
                    Anchors := anchors{ Minimum := vector2{ X := 0.5, Y := 0.08}, Maximum := vector2{ X := 0.5, Y := 0.08}}

        if (PlayerUI := GetPlayerUI[Player]):
            PlayerUI.AddWidget(NewCanvas)
            spawn:
                UpdateRunValue(Player, TextWidget)

    # Refresca el text cada poc temps amb el valor de ronda actual.
    UpdateRunValue(Player : player, TextBlock : text_block)<suspends> : void =
        loop:
            Sleep(0.4)
            Value := State.GetRunValue(Player)
            TextBlock.SetText(ValueText(Value))

    HandlePlayerJoin(Agent : agent) : void =
        if (Player := player[Agent]):
            State.InitializePlayer(Player)
            Player.InitUI()

    OnBegin<override>()<suspends>:void=
        GetPlayspace().PlayerAddedEvent().Subscribe(HandlePlayerJoin)
        for (Player : GetPlayspace().GetPlayers()):
            State.InitializePlayer(Player)
            Player.InitUI()
