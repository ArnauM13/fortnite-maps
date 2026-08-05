using { /Fortnite.com/Devices }
using { /Fortnite.com/Characters }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/SpatialMath }

# Place ONE large, invisible Trigger Device below the entire build - wide
# enough to cover the full play area horizontally, and low enough that a
# falling player always passes through it before hitting the void/water -
# and assign it to FallResetZone below.
#
# Any player who touches it is teleported back to the last climb_checkpoint
# they reached, instead of falling forever, drowning, or being eliminated.
# Players who fall before reaching any checkpoint are sent back to where
# they originally spawned.
fall_reset_manager := class(creative_device):

    @editable
    FallResetZone:trigger_device = trigger_device{}

    OnBegin<override>()<suspends>:void=
        FallResetZone.TriggeredEvent.Subscribe(OnPlayerFell)
        GetPlayspace().PlayerAddedEvent().Subscribe(OnPlayerJoin)

    # Records each player's spawn position as a fallback checkpoint, in case
    # they fall before reaching their first real climb_checkpoint.
    OnPlayerJoin(Agent:agent):void=
        if (Player := player[Agent]):
            spawn:
                RecordInitialSpawn(Player)

    RecordInitialSpawn(Player:player)<suspends>:void=
        Sleep(0.5)
        if:
            not LastCheckpointMap[Player]
            FortCharacter := Player.GetFortCharacter[]
            Position := FortCharacter.GetTransform().Translation
            set LastCheckpointMap[Player] = checkpoint_data:
                X := Position.X
                Y := Position.Y
                Z := Position.Z
        else:
            Print("Skipped initial spawn checkpoint (already set or character unavailable)")

    OnPlayerFell(MaybeAgent:?agent):void=
        if:
            Agent := MaybeAgent?
            Player := player[Agent]
            FortCharacter := Player.GetFortCharacter[]
            CheckpointData := LastCheckpointMap[Player]
            RespawnPosition := vector3{X := CheckpointData.X, Y := CheckpointData.Y, Z := CheckpointData.Z}
        then:
            if (FortCharacter.TeleportTo[RespawnPosition, rotation{}]):
            else:
                Print("Checkpoint teleport failed for player - check FallResetZone/checkpoint placement")
