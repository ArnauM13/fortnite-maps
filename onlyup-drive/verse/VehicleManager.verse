using { /Fortnite.com/Devices }
using { /Fortnite.com/Characters }
using { /Fortnite.com/Game }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

# Gestiona els vehicles CONDUÏBLES de la capa "Street Takeover".
# Els vehicles-plataforma (mòbils/rotatoris) es fan amb prop_mover a UEFN, NO aquí.
# Aquí només: spawn dels conduïbles a spawn/cim i el "joyride" secret opcional.
vehicle_manager := class(creative_device):

    # Conduïbles del meet a l'spawn (esportiu, pickup, moto...).
    @editable SpawnVehicles : []vehicle_spawner_device = array{}
    # Vehicle-trofeu conduïble al cim (es desbloqueja en arribar).
    @editable SummitVehicle : vehicle_spawner_device = vehicle_spawner_device{}
    # Joyride secret: un vehicle amagat que et deixa baixar en picat per diversió.
    @editable JoyrideVehicle : vehicle_spawner_device = vehicle_spawner_device{}
    @editable JoyrideTrigger : trigger_device = trigger_device{}
    # Trigger del cim (mateix que FINISH o un de dedicat) per revelar el trofeu.
    @editable SummitTrigger : trigger_device = trigger_device{}
    @editable SpawnVehiclesAtStart : logic = true

    OnBegin<override>()<suspends> : void =
        if (SpawnVehiclesAtStart?):
            for (V : SpawnVehicles):
                V.AssignDriver(false)  # deixa'ls preparats i buits al meet
        race:
            RevealSummitTrophy()
            ListenJoyride()

    RevealSummitTrophy()<suspends> : void =
        loop:
            OptAgent := SummitTrigger.TriggeredEvent.Await()
            if (Agent := OptAgent?):
                # En arribar al cim, apareix el muscle car trofeu conduïble.
                SummitVehicle.Enable()
                Print("Cim: cotxe-trofeu desbloquejat.")

    ListenJoyride()<suspends> : void =
        loop:
            OptAgent := JoyrideTrigger.TriggeredEvent.Await()
            if (Agent := OptAgent?):
                JoyrideVehicle.Enable()
                Print("Joyride secret activat.")
