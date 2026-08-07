using { /Fortnite.com/Devices }
using { /Fortnite.com/Characters }
using { /Fortnite.com/Game }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/SpatialMath }

# beacon_manager  (EVOLUCIÓ v2 — sistema original)
# A més dels punts d'extracció fixos, un jugador pot CRIDAR una balisa i obrir
# una extracció temporal al seu lloc actual. El preu: la balisa AVISA tothom de
# la seva posició durant uns segons. Muntes la teva sortida... i anuncies on ets
# amb el botí a sobre.
#
# No copiat de cap mapa: mecànica de balisa pública amb finestra temporal.

beacon_manager := class(creative_device):

    # Botó/objecte que el jugador activa per cridar la balisa (bengala).
    @editable CallButton : conditional_button_device = conditional_button_device{}

    # Pool de zones de captura reutilitzables per a l'extracció temporal.
    @editable BeaconAreas : []capture_area_device = array{}

    # Prop visual de la balisa (fum/llum) que es teleporta al lloc de la crida.
    @editable BeaconProps : []creative_prop = array{}

    # HUD que avisa TOTHOM d'on s'ha obert una balisa.
    @editable BroadcastHUD : hud_message_device = hud_message_device{}

    # Segons que la balisa roman oberta abans de tancar-se.
    @editable BeaconDurationSeconds : float = 30.0

    # Segons de canalització dins la balisa per extreure.
    @editable ChannelSeconds : float = 8.0

    # Sistemes de dades per confirmar l'extracció.
    @editable Inventory : inventory_manager = inventory_manager{}
    @editable Missions : mission_manager = mission_manager{}

    # Ranura lliure per a la propera balisa (índex al pool).
    var NextSlot : int = 0

    OnBegin<override>()<suspends>:void=
        for (Area : BeaconAreas):
            Area.Disable()
        # Escoltar crides de balisa i captures d'extracció en paral·lel.
        race:
            ListenCalls()
            ListenBeaconCaptures()

    # Escolta cada cop que un jugador crida una balisa.
    ListenCalls()<suspends> : void =
        loop:
            MaybeAgent := CallButton.ActivatedEvent.Await()
            if (Agent := MaybeAgent?, Caller := player[Agent], FortChar := Caller.GetFortCharacter[]):
                OpenBeacon(FortChar.GetTransform().Translation)

    # Obre una balisa al lloc indicat i avisa tothom; es tanca sola al cap d'un temps.
    OpenBeacon(Position : vector3) : void =
        Index := NextSlot
        if:
            Area := BeaconAreas[Index]
            Prop := BeaconProps[Index]
        then:
            MoveTo(Prop, Position)
            if (Area.TeleportTo[Position, rotation{}]) {}
            Area.Enable()
            BroadcastToAll()
            Print("Balisa: extracció temporal OBERTA — avisant tothom")
            set NextSlot = if (Wrapped := Mod[Index + 1, BeaconAreas.Length]) then Wrapped else 0
            spawn { AutoCloseBeacon(Index) }

    # Tanca la balisa passat el temps.
    AutoCloseBeacon(Index : int)<suspends> : void =
        Sleep(BeaconDurationSeconds)
        if (Area := BeaconAreas[Index]):
            Area.Disable()
            Print("Balisa: tancada (temps esgotat)")

    # Avisa tots els jugadors connectats de la nova balisa.
    BroadcastToAll() : void =
        for (Player : GetPlayspace().GetPlayers()):
            BroadcastHUD.Show(Player)

    # Escolta captures completes a qualsevol balisa → extracció.
    ListenBeaconCaptures()<suspends> : void =
        loop:
            # Recorre el pool escoltant la primera captura que es produeixi.
            race:
                for (Area : BeaconAreas):
                    ListenArea(Area)

    ListenArea(Area : capture_area_device)<suspends> : void =
        loop:
            Agent := Area.AgentEntersEvent.Await()
            if (Extracting := player[Agent]):
                Value := Inventory.CommitRunLoot(Extracting)
                Missions.RegisterExtraction(Extracting, Value)
                Area.Disable()
                Print("Balisa: extracció EXITOSA de {Value} 💠")

    MoveTo(Prop : creative_prop, Position : vector3) : void =
        Where := transform:
            Translation := Position
            Rotation := rotation{}
            Scale := vector3{X := 1.0, Y := 1.0, Z := 1.0}
        if (Prop.TeleportTo[Where, false]) {}
