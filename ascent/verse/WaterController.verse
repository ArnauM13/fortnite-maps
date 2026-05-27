using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/SpatialMath }

# Mou el prop visual de l'aigua cap amunt contínuament.
# Activa damage_volume_device progressivament a mesura que puja.
# La velocitat augmenta un AccelerationRate per cada zona superada.

water_controller := class(creative_device):

    # Prop visual de l'aigua (mesh pla blau/cian gran centrat al mapa)
    @editable WaterProp : creative_prop = creative_prop{}

    # Posició X,Y del centre del prop d'aigua (per no forçar origen 0,0)
    @editable WaterCenterX : float = 0.0
    @editable WaterCenterY : float = 0.0

    # Alçada inicial (per sota del terra de la Zona 1)
    @editable StartHeight : float = -800.0

    # Velocitat base en units/segon a la Zona 1
    @editable BaseRiseSpeed : float = 120.0

    # Factor d'acceleració per zona (+10% per defecte)
    @editable AccelerationRate : float = 0.10

    # Alçada màxima (just per sota la plataforma de victòria)
    @editable MaxHeight : float = 27000.0

    # Damage volumes col·locats al mapa, ordenats de baix a dalt.
    # S'activen progressivament quan l'aigua els supera.
    @editable DamageZones : []damage_volume_device = array{}

    # Cada damage volume cobreix aquesta alçada (units)
    @editable DamageZoneHeight : float = 600.0

    # Quants damage zones s'activen per davant de la superfície visible
    # (permet que el jugador mori si el toca, no just quan el mesh el cobreix)
    @editable DamageZoneLeadDistance : float = 50.0

    var IsRising : logic = false
    var CurrentHeight : float = -800.0
    var CurrentZone : int = 1

    OnBegin<override>()<suspends> : void =
        set CurrentHeight = StartHeight
        MoveWaterProp(StartHeight)

    StartWaterRise() : void =
        set IsRising = true
        Print("[Agua] Pujada iniciada — {BaseRiseSpeed} u/s")
        spawn { RiseLoop() }

    StopWaterRise() : void =
        set IsRising = false
        Print("[Agua] Aturada a z={CurrentHeight}")

    # Cridat per CheckpointTracker quan el jugador avança de zona
    SetZone(Zone : int) : void =
        set CurrentZone = Zone
        Print("[Agua] Zona {Zone} — {GetCurrentSpeed()} u/s")

    GetCurrentHeight() : float = CurrentHeight

    GetCurrentSpeed() : float =
        let ZoneBonus : float = float(CurrentZone - 1) * AccelerationRate
        BaseRiseSpeed * (1.0 + ZoneBonus)

    # Bucle principal: tick cada 0.1s per moviment fluid
    RiseLoop()<suspends> : void =
        let Tick : float = 0.1
        loop:
            if (not IsRising):
                break
            if (CurrentHeight >= MaxHeight):
                Print("[Agua] Alçada màxima assolida")
                break
            set CurrentHeight = CurrentHeight + GetCurrentSpeed() * Tick
            MoveWaterProp(CurrentHeight)
            ActivateDamageZonesUpTo(CurrentHeight + DamageZoneLeadDistance)
            Sleep(Tick)

    MoveWaterProp(Height : float) : void =
        let NewTransform : transform = transform:
            Translation := vector3{X := WaterCenterX, Y := WaterCenterY, Z := Height}
            Rotation := rotation{}
            Scale := vector3{X := 1.0, Y := 1.0, Z := 1.0}
        if (WaterProp.TeleportTo[NewTransform]):
            false
        else:
            false

    # Activa les damage zones que queden per sota de l'alçada indicada
    ActivateDamageZonesUpTo(Height : float) : void =
        for (Index -> Zone : DamageZones):
            let Threshold : float = StartHeight + float(Index + 1) * DamageZoneHeight
            if (Height >= Threshold):
                Zone.Enable()
