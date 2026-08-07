using { /Fortnite.com/Devices }
using { /Fortnite.com/Characters }
using { /Fortnite.com/UI }
using { /Verse.org/Simulation }
using { /Verse.org/Colors }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /UnrealEngine.com/Temporary/UI }

# See https://dev.epicgames.com/documentation/en-us/uefn/create-your-own-device-in-verse for how to create a verse device.

# A Verse-authored creative device that can be placed in a level
distance_device := class(creative_device):

    # Tracks and persists each player's best-height record (see
    # player_climb_stats.verse / player_climb_manager.verse).
    ClimbManager:player_climb_manager = player_climb_manager{}

    UIText<localizes>(Value : string) : message = "{Value}"
    NewBestUIText<localizes>(Value : string) : message = "{Value}  NEW BEST!"

    (Player : player).InitUI() : void =

        TextWidget : text_block = text_block{DefaultTextColor := NamedColors.White}
        NewCanvas : canvas = canvas:
            Slots := array:
                canvas_slot:
                    Widget := TextWidget
                    Anchors := anchors{ Minimum := vector2{ X := 0.5, Y := 0.8}, Maximum := vector2{ X := 0.5, Y := 0.8}}
               
        if (PlayerUI := GetPlayerUI[Player], FortCharacter := Player.GetFortCharacter[]):
            PlayerUI.AddWidget(NewCanvas)
            spawn:
                FortCharacter.UpdateDistance(TextWidget)

    (FortCharacter : fort_character).UpdateDistance( TextBlock : text_block)<suspends> : void =
        loop:
            Sleep(0.4)
            DistanceVerticalMeters := FortCharacter.GetTransform().Translation.Z / 100.0
            if (RoundedDistance := Floor[DistanceVerticalMeters] - 0, Agent := FortCharacter.GetAgent[]):
                IsNewBest := ClimbManager.ReportHeight(Agent, RoundedDistance)
                if (IsNewBest?):
                    TextBlock.SetText(NewBestUIText("- {RoundedDistance}m -"))
                else:
                    TextBlock.SetText(UIText("- {RoundedDistance}m -"))

    HandlePlayerJoin(Agent : agent) : void =
        if (Player := player[Agent]):
            ClimbManager.InitializePlayer(Player)
            Player.InitUI()

    OnBegin<override>()<suspends>:void=
        GetPlayspace().PlayerAddedEvent().Subscribe(HandlePlayerJoin)

        for (Player : GetPlayspace().GetPlayers()):
            ClimbManager.InitializePlayer(Player)
            Player.InitUI()