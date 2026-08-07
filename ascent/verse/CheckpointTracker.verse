using { /Fortnite.com/Devices }
using { /Fortnite.com/Characters }
using { /Fortnite.com/Game }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

checkpoint_tracker := class(creative_device):

    @editable Checkpoint1 : trigger_device = trigger_device{}
    @editable Checkpoint2 : trigger_device = trigger_device{}
    @editable Checkpoint3 : trigger_device = trigger_device{}
    @editable Checkpoint4 : trigger_device = trigger_device{}
    @editable Checkpoint5 : trigger_device = trigger_device{}
    @editable HUDMessage : hud_message_device = hud_message_device{}
    @editable Water : water_controller = water_controller{}

    var CurrentZone : int = 0

    OnBegin<override>()<suspends> : void =
        race:
            ListenCheckpoint(Checkpoint1, 1)
            ListenCheckpoint(Checkpoint2, 2)
            ListenCheckpoint(Checkpoint3, 3)
            ListenCheckpoint(Checkpoint4, 4)
            ListenCheckpoint(Checkpoint5, 5)

    ListenCheckpoint(CP : trigger_device, ZoneNumber : int)<suspends> : void =
        loop:
            OptAgent := CP.TriggeredEvent.Await()
            if (ZoneNumber > CurrentZone, Agent := OptAgent?):
                set CurrentZone = ZoneNumber
                OnCheckpointActivated(ZoneNumber, Agent)

    OnCheckpointActivated(ZoneNumber : int, Agent : agent) : void =
        Water.SetZone(ZoneNumber)
        HUDMessage.Show(Agent)
        Print("Checkpoint activat: Zona {ZoneNumber}")

    GetCurrentZone() : int = CurrentZone
