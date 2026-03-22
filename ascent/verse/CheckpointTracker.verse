using { /Fortnite.com/Devices }
using { /Fortnite.com/Characters }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

# CheckpointTracker — Gestiona els 5 checkpoints del mapa
# Guarda la zona actual de cada jugador i gestiona respawns

checkpoint_tracker := class(creative_device):

    # Els 5 checkpoints (un per zona)
    @editable Checkpoint1 : checkpoint_device = checkpoint_device{}  # Soterrani
    @editable Checkpoint2 : checkpoint_device = checkpoint_device{}  # Aparcament
    @editable Checkpoint3 : checkpoint_device = checkpoint_device{}  # Oficines
    @editable Checkpoint4 : checkpoint_device = checkpoint_device{}  # Teulades
    @editable Checkpoint5 : checkpoint_device = checkpoint_device{}  # Cim

    OnBegin<override>()<suspends> : void =
        # Escoltar activació de cada checkpoint en paral·lel
        sync:
            ListenCheckpoint(Checkpoint1, 1)
            ListenCheckpoint(Checkpoint2, 2)
            ListenCheckpoint(Checkpoint3, 3)
            ListenCheckpoint(Checkpoint4, 4)
            ListenCheckpoint(Checkpoint5, 5)

    # Escolta un checkpoint i notifica quan s'activa
    ListenCheckpoint(CP : checkpoint_device, ZoneNumber : int)<suspends> : void =
        loop:
            CP.CheckpointActivatedEvent.Await()
            Print("Checkpoint {ZoneNumber} activat — Zona {ZoneNumber} desblocat")
