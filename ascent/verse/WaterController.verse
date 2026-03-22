using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/SpatialMath }

# WaterController
# Mou el prop visual de l'aigua i activa zones de dany progressivament.
# L'aigua s'accelera lleugerament a cada zona per augmentar la tensió.

water_controller := class(creative_device):

    # Prop visual de l'aigua (mesh pla blau/cian gran)
    @editable WaterProp : creative_prop = creative_prop{}

    # Alçada inicial de l'aigua (sota el terra de la Zona 1)
    @editable StartHeight : float = -800.0

    # Velocitat base de pujada en units/segon (Zona 1)
    @editable BaseRiseSpeed : float = 120.0

    # Factor d'acceleració per zona (+10% per defecte)
    @editable AccelerationRate : float = 0.10

    # Alçada màxima (just sota la plataforma de victòria)
    @editable MaxHeight : float = 27000.0

    # Zones de dany pre-col·locades al mapa (una per cada "nivell" d'alçada)
    # Afegeix-ne tantes com vulguis al UEFN editor, s'activaran en ordre de baix a dalt
    @editable DamageZones : []damage_volume_device = array{}

    # Cada zona de dany cobreix aquesta alçada (units)
    @editable DamageZoneHeight : float = 600.0

    # --- Estat intern ---
    var IsRising : logic = false
    var CurrentHeight : float = -800.0
    var CurrentZone : int = 1

    OnBegin<override>()<suspends> : void =
        set CurrentHeight = StartHeight
        MoveWaterProp(StartHeight)

    # Inicia la pujada — cridat pel GameManager
    StartWaterRise() : void =
        set IsRising = true
        Print("Aigua: Pujada iniciada — velocitat base {BaseRiseSpeed} u/s")
        spawn { RiseLoop() }

    # Atura la pujada — cridat en victòria o fi de partida
    StopWaterRise() : void =
        set IsRising = false
        Print("Aigua: Pujada aturada a {CurrentHeight} units")

    # Actualitza la zona actual per ajustar la velocitat
    # Cridat pel CheckpointTracker quan el jugador avança de zona
    SetZone(Zone : int) : void =
        set CurrentZone = Zone
        let Speed : float = GetCurrentSpeed()
        Print("Aigua: Zona {Zone} — nova velocitat {Speed} u/s")

    # Retorna l'alçada actual (usada pel TimerDisplay per avisar de proximitat)
    GetCurrentHeight() : float = CurrentHeight

    # Retorna la velocitat actual tenint en compte la zona
    GetCurrentSpeed() : float =
        let ZoneBonus : float = float(CurrentZone - 1) * AccelerationRate
        return BaseRiseSpeed * (1.0 + ZoneBonus)

    # Bucle principal de pujada (s'executa cada segon)
    RiseLoop()<suspends> : void =
        loop:
            if (not IsRising):
                break
            if (CurrentHeight >= MaxHeight):
                Print("Aigua: Alçada màxima assolida")
                break

            let RiseAmount : float = GetCurrentSpeed()
            set CurrentHeight = CurrentHeight + RiseAmount
            MoveWaterProp(CurrentHeight)
            ActivateDamageZonesUpTo(CurrentHeight)

            Sleep(1.0)

    # Mou el prop visual de l'aigua a la nova alçada
    MoveWaterProp(Height : float) : void =
        let NewTransform : transform = transform:
            Translation := vector3{X := 0.0, Y := 0.0, Z := Height}
            Rotation := rotation{}
            Scale := vector3{X := 1.0, Y := 1.0, Z := 1.0}
        if (WaterProp.TeleportTo[NewTransform, false]):
            false
        else:
            false

    # Activa les damage zones que queden per sota de l'alçada actual
    # Les zones han d'estar col·locades al UEFN ordenades de baix a dalt
    ActivateDamageZonesUpTo(Height : float) : void =
        for (Index -> Zone : DamageZones):
            let ZoneThreshold : float = StartHeight + (float(Index) * DamageZoneHeight)
            if (Height >= ZoneThreshold):
                Zone.Enable()
