using { /Fortnite.com/Devices }
using { /Fortnite.com/Characters }
using { /Fortnite.com/Game }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

# Reset per caiguda total: un volum al fons del buit (Z molt negatiu).
# En Only Up caure NO mata; només tornes avall. Aquest volum atrapa qui cau del tot
# i el retorna al seu últim checkpoint (o a l'spawn si no en té cap).
fall_reset_manager := class(creative_device):

    @editable VoidVolume : trigger_device = trigger_device{}
    @editable Checkpoints : checkpoint_manager = checkpoint_manager{}
    @editable Coins : coin_manager = coin_manager{}
    @editable SpawnTeleporter : teleporter_device = teleporter_device{}
    @editable ResetFeedback : hud_message_device = hud_message_device{}

    OnBegin<override>()<suspends> : void =
        loop:
            OptAgent := VoidVolume.TriggeredEvent.Await()
            if (Agent := OptAgent?):
                ResetPlayer(Agent)

    ResetPlayer(Agent : agent) : void =
        # Caure trenca la ratxa "sense caure".
        Coins.ResetStreak(Agent)
        # Primer prova de deixar-lo al seu checkpoint; si no en té, a l'spawn.
        if (Checkpoints.RespawnAtLast(Agent)):
            ResetFeedback.Show(Agent)
            Print("Reset al darrer checkpoint.")
        else:
            SpawnTeleporter.Teleport(Agent)
            ResetFeedback.Show(Agent)
            Print("Reset a l'spawn (cap checkpoint).")
