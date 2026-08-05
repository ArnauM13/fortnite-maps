using { /Fortnite.com/Characters }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

# A checkpoint position, stored per player. Module-scope 'var's in Verse must
# be 'weak_map', and weak_map values must be persistable, so this is a small
# persistable class of plain floats rather than the native 'transform' type.
# As a side effect, each player's last checkpoint now also survives
# reconnecting mid-session (though not across island republishes).
checkpoint_data<public> := class<final><persistable>:
    X<public>:float = 0.0
    Y<public>:float = 0.0
    Z<public>:float = 0.0

# Shared state for the climb: the last checkpoint each player has reached.
# Read from fall_reset_manager.verse, written from climb_checkpoint.verse.
var LastCheckpointMap:weak_map(player, checkpoint_data) = map{}
