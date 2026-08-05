using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

# Place a Trigger Device on every platform along the climb where players
# should be able to respawn from after a fall, then duplicate THIS device
# next to it and assign that Trigger below.
#
# Tip: make each Trigger wide and thin (a flat plate flush with the
# platform) so players walk through it naturally while climbing - no button
# press required. You don't need to number them or keep them in order:
# whichever checkpoint a player last walked through becomes their respawn
# point, so higher checkpoints simply overwrite lower ones as players climb.
climb_checkpoint := class(creative_device):

    @editable
    Trigger:trigger_device = trigger_device{}

    OnBegin<override>()<suspends>:void=
        Trigger.TriggeredEvent.Subscribe(OnPlayerReachedCheckpoint)

    OnPlayerReachedCheckpoint(MaybeAgent:?agent):void=
        if:
            Agent := MaybeAgent?
            Player := player[Agent]
            Position := Trigger.GetTransform().Translation
            set LastCheckpointMap[Player] = checkpoint_data:
                X := Position.X
                Y := Position.Y
                Z := Position.Z
        else:
            Print("Checkpoint trigger fired without a valid player")
