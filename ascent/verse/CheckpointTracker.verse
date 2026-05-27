using { /Fortnite.com/Devices }
using { /Fortnite.com/Characters }
using { /Fortnite.com/Game }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

# Gestiona els 5 checkpoints del mapa.
# Quan s'activa un checkpoint: notifica el WaterController (zona nova)
# i mostra un missatge HUD específic per zona al jugador.

checkpoint_tracker := class(creative_device):

    # Els 5 checkpoints (un per zona) — assignar al UEFN editor
    @editable Checkpoint1 : checkpoint_device = checkpoint_device{}
    @editable Checkpoint2 : checkpoint_device = checkpoint_device{}
    @editable Checkpoint3 : checkpoint_device = checkpoint_device{}
    @editable Checkpoint4 : checkpoint_device = checkpoint_device{}
    @editable Checkpoint5 : checkpoint_device = checkpoint_device{}

    # Un hud_message_device per zona, configurat al editor amb el text de cada zona.
    # Exemple: "Zona 1 — Soterrani ✓ Checkpoint guardat"
    @editable ZoneHUDs : []hud_message_device = array{}

    # Referència al WaterController per pujar la velocitat en avançar de zona
    @editable Water : water_controller = water_controller{}

    # Zona actual (0 = no s'ha activat cap checkpoint encara)
    var CurrentZone : int = 0

    OnBegin<override>()<suspends> : void =
        # Cada checkpoint escolta de forma independent i indefinida
        spawn { ListenCheckpoint(Checkpoint1, 1) }
        spawn { ListenCheckpoint(Checkpoint2, 2) }
        spawn { ListenCheckpoint(Checkpoint3, 3) }
        spawn { ListenCheckpoint(Checkpoint4, 4) }
        spawn { ListenCheckpoint(Checkpoint5, 5) }

    ListenCheckpoint(CP : checkpoint_device, ZoneNumber : int)<suspends> : void =
        loop:
            let Payload := CP.CheckpointActivatedEvent.Await()
            # Només processar si és una zona nova (no un respawn al mateix CP)
            if (ZoneNumber > CurrentZone):
                set CurrentZone = ZoneNumber
                OnCheckpointActivated(ZoneNumber, Payload.Agent)

    OnCheckpointActivated(ZoneNumber : int, Agent : agent) : void =
        Print("[CP] Zona {ZoneNumber} activada")
        Water.SetZone(ZoneNumber)
        ShowZoneHUD(ZoneNumber, Agent)

    # Mostra el HUD de zona corresponent (configurat al editor amb el text)
    ShowZoneHUD(ZoneNumber : int, Agent : agent) : void =
        let HUDIndex : int = ZoneNumber - 1
        if (HUD := ZoneHUDs[HUDIndex]):
            HUD.Show(Agent)

    GetCurrentZone() : int = CurrentZone
