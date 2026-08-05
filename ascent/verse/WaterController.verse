using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/SpatialMath }

water_controller := class(creative_device):

    @editable WaterProp : creative_prop = creative_prop{}
    @editable StartHeight : float = -800.0
    @editable BaseRiseSpeed : float = 120.0
    @editable AccelerationRate : float = 0.10
    @editable MaxHeight : float = 27000.0
    @editable DamageZones : []damage_volume_device = array{}
    @editable DamageZoneHeight : float = 600.0

    var IsRising : logic = false
    var CurrentHeight : float = -800.0
    var CurrentZone : int = 1

    OnBegin<override>()<suspends> : void =
        set CurrentHeight = StartHeight
        MoveWaterProp(StartHeight)

    StartWaterRise() : void =
        set IsRising = true
        Print("Aigua: Pujada iniciada")
        spawn { RiseLoop() }

    StopWaterRise() : void =
        set IsRising = false

    SetZone(Zone : int) : void =
        set CurrentZone = Zone
        Print("Aigua: Zona {Zone}")

    GetCurrentHeight() : float = CurrentHeight

    GetCurrentSpeed() : float =
        if (CurrentZone >= 5):
            BaseRiseSpeed * 1.4
        else if (CurrentZone >= 4):
            BaseRiseSpeed * 1.3
        else if (CurrentZone >= 3):
            BaseRiseSpeed * 1.2
        else if (CurrentZone >= 2):
            BaseRiseSpeed * 1.1
        else:
            BaseRiseSpeed

    RiseLoop()<suspends> : void =
        loop:
            if (IsRising = false):
                break
            if (CurrentHeight >= MaxHeight):
                break
            RiseAmount : float = GetCurrentSpeed()
            set CurrentHeight = CurrentHeight + RiseAmount
            MoveWaterProp(CurrentHeight)
            ActivateDamageZonesUpTo(CurrentHeight)
            Sleep(1.0)

    MoveWaterProp(Height : float) : void =
        NewTransform : transform = transform:
            Translation := vector3{X := 0.0, Y := 0.0, Z := Height}
            Rotation := rotation{}
            Scale := vector3{X := 1.0, Y := 1.0, Z := 1.0}
        if (WaterProp.TeleportTo[NewTransform]):
            false

    ActivateDamageZonesUpTo(Height : float) : void =
        var ZoneBottom : float = StartHeight
        for (Zone : DamageZones):
            if (Height >= ZoneBottom):
                Zone.Enable()
            set ZoneBottom = ZoneBottom + DamageZoneHeight
