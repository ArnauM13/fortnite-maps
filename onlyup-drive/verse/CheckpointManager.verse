using { /Fortnite.com/Devices }
using { /Fortnite.com/Characters }
using { /Fortnite.com/Game }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

# Checkpoints OPCIONALS i comprables amb monedes.
# A cada estació: un volum (detecta presència), un botó de compra i un teleporter de respawn.
# Els tres arrays van en el mateix ordre (checkpoint 1..5).
checkpoint_manager := class(creative_device):

    @editable CheckpointVolumes : []trigger_device = array{}
    @editable BuyButtons : []button_device = array{}
    @editable RespawnTeleporters : []teleporter_device = array{}
    @editable Coins : coin_manager = coin_manager{}
    @editable PurchaseFeedback : hud_message_device = hud_message_device{}
    @editable CheckpointCost : int = 15

    # Índex del checkpoint comprat més alt, per jugador (-1 = cap).
    var Purchased : [agent]int = map{}

    OnBegin<override>()<suspends> : void =
        for (Index -> Buy : BuyButtons):
            spawn { ListenBuy(Buy, Index) }

    ListenBuy(Buy : button_device, Index : int)<suspends> : void =
        loop:
            OptAgent := Buy.InteractedWithEvent.Await()
            if (Agent := OptAgent?):
                TryBuy(Agent, Index)

    TryBuy(Agent : agent, Index : int) : void =
        if (Current := GetPurchased(Agent), Index <= Current):
            # Ja el tens (o un de superior): no cal tornar a pagar.
            PurchaseFeedback.Show(Agent)
        else if (Coins.TrySpend(Agent, CheckpointCost)):
            if (set Purchased[Agent] = Index):
                PurchaseFeedback.Show(Agent)
                Print("Checkpoint {Index} comprat.")
        else:
            # Sense monedes suficients.
            Print("Sense monedes per al checkpoint {Index}.")

    GetPurchased(Agent : agent) : int =
        if (P := Purchased[Agent]):
            return P
        return -1

    # Teletransporta el jugador al seu checkpoint més alt comprat.
    # Retorna true si l'ha pogut respawnejar en un checkpoint.
    RespawnAtLast(Agent : agent) : logic =
        Index := GetPurchased(Agent)
        if (Index >= 0, TP := RespawnTeleporters[Index]):
            TP.Teleport(Agent)
            return true
        return false
