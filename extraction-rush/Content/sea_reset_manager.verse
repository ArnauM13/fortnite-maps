using { /Fortnite.com/Devices }
using { /Fortnite.com/Characters }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/SpatialMath }

# sea_reset_manager
# Adaptació de 'fall_reset_manager.verse' (OnlyUp Naufragi). Encaixa amb la
# temàtica naval d'EXTRACTION RUSH: col·loca UN Trigger Device gran i invisible
# sobre el mar que envolta el mapa. Qualsevol jugador que caigui fora dels límits
# (al mar) és retornat al seu punt de desplegament en comptes de morir ofegat o
# quedar fora de joc — evita exploits de sortir del mapa sense castigar-ho amb la
# pèrdua del botí (això ho gestiona la tempesta i el PvP, no una caiguda accidental).
#
# Nota de disseny: a diferència del Naufragi (que teleporta a l'últim checkpoint
# de pujada), aquí no hi ha checkpoints de progrés — es retorna al deploy anchor.

sea_reset_manager := class(creative_device):

    # Trigger únic i ample que cobreix la superfície del mar sota/al voltant del mapa.
    @editable
    SeaZone:trigger_device = trigger_device{}

    # Alçada extra en retornar, per no aparèixer dins del terra.
    @editable
    RespawnHeightOffset:float = 100.0

    # Punt de desplegament de cada jugador, registrat en unir-se (fallback segur).
    var SpawnAnchor:[player]vector3 = map{}

    OnBegin<override>()<suspends>:void=
        SeaZone.TriggeredEvent.Subscribe(OnPlayerFellInSea)
        GetPlayspace().PlayerAddedEvent().Subscribe(OnPlayerJoin)

    # Registra el punt de deploy de cada jugador com a àncora de retorn.
    OnPlayerJoin(Agent:agent):void=
        if (Player := player[Agent]):
            spawn:
                RecordSpawn(Player)

    RecordSpawn(Player:player)<suspends>:void=
        Sleep(0.5)
        if:
            not SpawnAnchor[Player]
            FortCharacter := Player.GetFortCharacter[]
            Position := FortCharacter.GetTransform().Translation
            set SpawnAnchor[Player] = vector3:
                X := Position.X
                Y := Position.Y
                Z := Position.Z + RespawnHeightOffset
        else:
            Print("sea_reset: àncora de deploy ja registrada o personatge no disponible")

    # En tocar el mar, torna el jugador a la seva àncora conservant l'orientació.
    OnPlayerFellInSea(MaybeAgent:?agent):void=
        if:
            Agent := MaybeAgent?
            Player := player[Agent]
            FortCharacter := Player.GetFortCharacter[]
            Anchor := SpawnAnchor[Player]
            Facing := FortCharacter.GetTransform().Rotation
        then:
            if (FortCharacter.TeleportTo[Anchor, Facing]):
            else:
                Print("sea_reset: teleport fallit — revisa SeaZone/àncora del jugador")
        else:
            Print("sea_reset: caiguda al mar sense àncora registrada")
