using { /Fortnite.com/Devices }
using { /Fortnite.com/Characters }
using { /Fortnite.com/Game }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

# CheckpointTracker
# Gestiona els 5 checkpoints del mapa.
# En activar cada checkpoint: notifica el WaterController (zona nova)
# i mostra un missatge HUD al jugador.

checkpoint_tracker := class(creative_device):

    # Els 5 checkpoints, un per zona (assignar al UEFN editor)
    @editable Checkpoint1 : checkpoint_device = checkpoint_device{}  # Zona 1 — Soterrani
    @editable Checkpoint2 : checkpoint_device = checkpoint_device{}  # Zona 2 — Aparcament
    @editable Checkpoint3 : checkpoint_device = checkpoint_device{}  # Zona 3 — Oficines
    @editable Checkpoint4 : checkpoint_device = checkpoint_device{}  # Zona 4 — Teulades
    @editable Checkpoint5 : checkpoint_device = checkpoint_device{}  # Zona 5 — El Cim

    # Missatge HUD per mostrar feedback de checkpoint
    @editable HUDMessage : hud_message_device = hud_message_device{}

    # Referència al WaterController per actualitzar velocitat per zona
    @editable Water : water_controller = water_controller{}

    # Noms de les zones per als missatges HUD
    ZoneNames : []string = array:
        "Zona 1 — Soterrani"
        "Zona 2 — Aparcament"
        "Zona 3 — Oficines"
        "Zona 4 — Teulades"
        "Zona 5 — El Cim"

    # Zona actual del jugador (1–5)
    var CurrentZone : int = 0

    OnBegin<override>()<suspends> : void =
        # Escoltar tots els checkpoints en paral·lel
        race:
            ListenCheckpoint(Checkpoint1, 1)
            ListenCheckpoint(Checkpoint2, 2)
            ListenCheckpoint(Checkpoint3, 3)
            ListenCheckpoint(Checkpoint4, 4)
            ListenCheckpoint(Checkpoint5, 5)

    # Escolta un checkpoint i actua quan s'activa
    ListenCheckpoint(CP : checkpoint_device, ZoneNumber : int)<suspends> : void =
        loop:
            # Esperar a que el jugador activi aquest checkpoint
            let Payload := CP.CheckpointActivatedEvent.Await()

            # Ignorar si el jugador ja estava en una zona superior
            if (ZoneNumber > CurrentZone):
                set CurrentZone = ZoneNumber
                OnCheckpointActivated(ZoneNumber, Payload.Agent)

    # Executat quan un checkpoint nou és activat
    OnCheckpointActivated(ZoneNumber : int, Agent : agent) : void =
        # Actualitzar velocitat de l'aigua per la nova zona
        Water.SetZone(ZoneNumber)

        # Mostrar missatge HUD al jugador
        if (ZoneName := ZoneNames[ZoneNumber - 1]):
            HUDMessage.Show(Agent)
            Print("Checkpoint activat: {ZoneName}")
        else:
            Print("Checkpoint activat: Zona {ZoneNumber}")

    # Retorna la zona actual (usada pel GameManager)
    GetCurrentZone() : int = CurrentZone
