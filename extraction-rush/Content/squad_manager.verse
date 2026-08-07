using { /Fortnite.com/Devices }
using { /Fortnite.com/Characters }
using { /Fortnite.com/Game }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/SpatialMath }

# squad_manager  (EVOLUCIÓ v2 — sistema original)
# Gestiona la mort d'un jugador de manera que el botí NO desaparegui:
#   - En morir, deixa una BOSSA al terra amb tot el valor 💠 que portava.
#   - Qualsevol jugador que la reculli suma aquest valor al seu botí de ronda.
#     → Matar algú carregat és, literalment, robar-li la caixa forta.
#
# Usa un pool de "ranures de bossa" (prop visible + trigger de recollida)
# preposicionats al mapa; en una mort, la ranura lliure més propera es
# teleporta al lloc de la mort i s'activa.
#
# No copiat de cap mapa: lògica de transferència de botí pròpia.

# Una ranura de bossa reutilitzable.
bag_slot := class:
    Prop : creative_prop
    Trigger : trigger_device

squad_manager := class(creative_device):

    # Gestor d'eliminacions del mapa (font de les morts).
    @editable EliminationManager : elimination_manager_device = elimination_manager_device{}

    # Pool de props de bossa (visual) i triggers de recollida, aparellats per índex.
    @editable BagProps : []creative_prop = array{}
    @editable BagTriggers : []trigger_device = array{}

    # HUD de feedback ("has robat X 💠" / "has perdut el botí").
    @editable BagHUD : hud_message_device = hud_message_device{}

    # Referències als sistemes de dades.
    @editable Inventory : inventory_manager = inventory_manager{}
    @editable Missions : mission_manager = mission_manager{}

    State : extraction_state = extraction_state{}

    # Valor guardat a cada ranura de bossa activa (per índex). 0 = ranura lliure.
    var BagValue : [int]int = map{}

    OnBegin<override>()<suspends>:void=
        # Amagar totes les bosses al començar i escoltar-ne la recollida.
        for (Index -> Slot : BuildSlots()):
            Slot.Trigger.Disable()
            spawn { ListenBagPickup(Index, Slot) }
        # Escoltar morts.
        EliminationManager.EliminatedEvent.Subscribe(OnElimination)

    # Aparella props i triggers en objectes bag_slot.
    BuildSlots() : []bag_slot =
        for (Index -> Prop : BagProps, Trigger := BagTriggers[Index]):
            bag_slot{ Prop := Prop, Trigger := Trigger }

    # Mort d'un jugador: deixa caure la seva bossa; l'eliminador rep XP.
    OnElimination(Result : elimination_result) : void =
        # L'eliminat perd el botí de ronda... però cap a una bossa al terra.
        if:
            Victim := player[Result.EliminatedCharacter.GetAgent[]]
            FortChar := Result.EliminatedCharacter
        then:
            DropBag(Victim, FortChar.GetTransform().Translation)

        # L'eliminador (si és jugador) rep XP per l'eliminació.
        if:
            KillerAgent := Result.EliminatingCharacter?.GetAgent[]
            Killer := player[KillerAgent]
        then:
            Missions.RegisterElimination(Killer)

    # Crea una bossa amb el valor de ronda de la víctima al lloc de la mort.
    DropBag(Victim : player, Position : vector3) : void =
        Value := State.GetRunValue(Victim)
        State.ClearRunValue(Victim)  # ja no el porta a sobre; ara és al terra
        if (Value <= 0):
            Print("squad: víctima sense botí — cap bossa")
            return

        if (Index := FreeBagSlot[]):
            Slots := BuildSlots()
            if (Slot := Slots[Index]):
                MoveBagTo(Slot, Position)
                Slot.Trigger.Enable()
                if (set BagValue[Index] = Value) {}
                Print("squad: bossa de {Value} 💠 deixada al terra")
        else:
            Print("squad: sense ranures de bossa lliures (perdut {Value} 💠)")

    # Teleporta el prop i el trigger de la ranura al lloc de la mort.
    MoveBagTo(Slot : bag_slot, Position : vector3) : void =
        Where := transform:
            Translation := Position
            Rotation := rotation{}
            Scale := vector3{X := 1.0, Y := 1.0, Z := 1.0}
        if (Slot.Prop.TeleportTo[Where, false]) {}
        if (Slot.Trigger.TeleportTo[Position, rotation{}]) {}

    # Escolta la recollida d'una bossa concreta.
    ListenBagPickup(Index : int, Slot : bag_slot)<suspends> : void =
        loop:
            MaybeAgent := Slot.Trigger.TriggeredEvent.Await()
            if:
                Agent := MaybeAgent?
                Looter := player[Agent]
                Value := BagValue[Index]
                Value > 0
            then:
                # Transferir el valor de la bossa al botí de ronda del saquejador.
                Inventory.AddRunLoot(Looter, Value)
                if (set BagValue[Index] = 0) {}
                Slot.Trigger.Disable()
                BagHUD.Show(Agent)
                Print("squad: {Value} 💠 robats d'una bossa")

    # Primera ranura de bossa lliure (valor 0 o sense entrada).
    FreeBagSlot() : ?int =
        for (Index := 0..(BagProps.Length - 1)):
            Occupied := if (V := BagValue[Index]) then V > 0 else false
            if (not Occupied?):
                return option{Index}
        false
