using { /Fortnite.com/Devices }
using { /Fortnite.com/Characters }
using { /Fortnite.com/Game }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

# loadout_shop  (EVOLUCIÓ v2 — sistema original)
# Al lobby, el jugador gasta el valor 💠 de la seva estança per:
#   - Entrar amb un LOADOUT millor (per nivells).
#   - ASSEGURAR una arma: si mor aquesta ronda, la recupera al proper deploy.
# Tanca el bucle econòmic: el que extreus finança el que arrisques.
#
# No copiat de cap mapa: preus, nivells i lògica d'assegurança propis.

# Un nivell de loadout comprable.
loadout_tier := class:
    Button : conditional_button_device   # botó de compra al lobby
    Granter : item_granter_device        # atorga les armes/objectes del nivell
    Cost : int                           # preu en 💠

loadout_shop := class(creative_device):

    # Nivells de loadout (assignar botó + granter + cost a l'editor).
    # Recomanat (veure docs/economy.md): Operatiu 300, Veterà 1000, Fantasma 3000.
    @editable Tier1Button : conditional_button_device = conditional_button_device{}
    @editable Tier1Granter : item_granter_device = item_granter_device{}
    @editable Tier1Cost : int = 300

    @editable Tier2Button : conditional_button_device = conditional_button_device{}
    @editable Tier2Granter : item_granter_device = item_granter_device{}
    @editable Tier2Cost : int = 1000

    @editable Tier3Button : conditional_button_device = conditional_button_device{}
    @editable Tier3Granter : item_granter_device = item_granter_device{}
    @editable Tier3Cost : int = 3000

    # Botó per assegurar l'arma equipada i granter que la retorna al deploy.
    @editable InsureButton : conditional_button_device = conditional_button_device{}
    @editable InsuranceGranter : item_granter_device = item_granter_device{}
    @editable InsuranceCost : int = 500

    # HUD de feedback de compra.
    @editable ShopHUD : hud_message_device = hud_message_device{}

    @editable Inventory : inventory_manager = inventory_manager{}

    # Jugadors amb assegurança activa aquesta ronda.
    var Insured : [player]logic = map{}

    OnBegin<override>()<suspends>:void=
        race:
            ListenTier(Tier1Button, Tier1Granter, Tier1Cost, "Operatiu")
            ListenTier(Tier2Button, Tier2Granter, Tier2Cost, "Veterà")
            ListenTier(Tier3Button, Tier3Granter, Tier3Cost, "Fantasma")
            ListenInsurance()
            ListenRespawnGrant()

    # Escolta compres d'un nivell de loadout.
    ListenTier(Button : conditional_button_device, Granter : item_granter_device, Cost : int, Name : string)<suspends> : void =
        loop:
            MaybeAgent := Button.ActivatedEvent.Await()
            if (Agent := MaybeAgent?, Buyer := player[Agent]):
                if (Inventory.SpendStash(Buyer, Cost)):
                    Granter.GrantItem(Agent)
                    ShopHUD.Show(Agent)
                    Print("Botiga: loadout {Name} comprat (-{Cost} 💠)")
                else:
                    Print("Botiga: sense fons per a {Name} ({Cost} 💠)")

    # Escolta la compra d'assegurança.
    ListenInsurance()<suspends> : void =
        loop:
            MaybeAgent := InsureButton.ActivatedEvent.Await()
            if (Agent := MaybeAgent?, Buyer := player[Agent]):
                if (Inventory.SpendStash(Buyer, InsuranceCost)):
                    if (set Insured[Buyer] = true) {}
                    ShopHUD.Show(Agent)
                    Print("Botiga: assegurança activada (-{InsuranceCost} 💠)")
                else:
                    Print("Botiga: sense fons per a assegurança")

    # En reaparèixer (nou deploy), retorna l'arma assegurada i consumeix l'assegurança.
    ListenRespawnGrant()<suspends> : void =
        loop:
            Agent := GetPlayspace().PlayerSpawnedEvent().Await()
            if (Player := player[Agent], IsInsured := Insured[Player], IsInsured?):
                InsuranceGranter.GrantItem(Agent)
                if (set Insured[Player] = false) {}  # assegurança d'un sol ús
                Print("Botiga: arma assegurada retornada al deploy")
