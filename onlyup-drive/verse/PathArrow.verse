using { /Fortnite.com/Devices }
using { /Fortnite.com/Characters }
using { /Fortnite.com/Game }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

# FLETXA INDICADORA — guia "cap on has d'anar".
#
# En un Only Up el jugador mai ha de dubtar la direcció. Aquest dispositiu
# encén el grup de fletxes de neó de la secció on ets (i el següent), i apaga
# les de darrere, perquè només brillin les rellevants (sense saturar).
#
# Cada "interruptor" és un trigger_device co-situat amb les fletxes de neó de
# la seva secció; Enable()/Disable() encén/apaga el grup (o, a UEFN, també pots
# fer servir el marcador/waypoint on-screen de Fortnite cap al següent checkpoint).
path_arrow := class(creative_device):

    # Triggers d'entrada de secció (els mateixos que height_tracker), en ordre.
    @editable SectionTriggers : []trigger_device = array{}
    # Un interruptor de grup de fletxes per secció, en el mateix ordre.
    @editable ArrowSwitches : []trigger_device = array{}
    # Opcional: fletxa/marcador que apunta directament al proper checkpoint.
    @editable NextCheckpointMarker : trigger_device = trigger_device{}
    @editable ShowNextAndCurrent : logic = true

    var CurrentSection : int = 0

    OnBegin<override>()<suspends> : void =
        # Estat inicial: encén la secció 0 (i la 1 si escau).
        EnableForSection(0)
        for (Index -> Trig : SectionTriggers):
            spawn { ListenSection(Trig, Index) }

    ListenSection(Trig : trigger_device, Index : int)<suspends> : void =
        loop:
            OptAgent := Trig.TriggeredEvent.Await()
            if (OptAgent?, Index > CurrentSection):
                set CurrentSection = Index
                EnableForSection(Index)

    EnableForSection(Index : int) : void =
        # Apaga tots els grups i encén el de la secció actual (+ el següent).
        for (I -> Switch : ArrowSwitches):
            KeepOn := I = Index or (ShowNextAndCurrent? and I = Index + 1)
            if (KeepOn?):
                Switch.Enable()
            else:
                Switch.Disable()
        Print("Fletxes: secció {Index} (i següent) enceses.")
