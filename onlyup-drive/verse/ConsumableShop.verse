using { /Fortnite.com/Devices }
using { /Fortnite.com/Characters }
using { /Fortnite.com/Game }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

# Potenciadors d'un sol ús comprats amb FITXES (⚡) durant l'escalada.
# Nitro Surge (8), Hover Save (12), Imant (6), Rebobinar (15). Veure economy.md.
consumable_shop := class(creative_device):

    @editable BuyNitro : button_device = button_device{}
    @editable BuyHover : button_device = button_device{}
    @editable BuyMagnet : button_device = button_device{}
    @editable BuyRewind : button_device = button_device{}
    @editable Coins : coin_manager = coin_manager{}
    @editable Feedback : hud_message_device = hud_message_device{}

    NitroCost : int = 8
    HoverCost : int = 12
    MagnetCost : int = 6
    RewindCost : int = 15

    OnBegin<override>()<suspends> : void =
        spawn { Listen(BuyNitro, NitroCost, "nitro") }
        spawn { Listen(BuyHover, HoverCost, "hover") }
        spawn { Listen(BuyMagnet, MagnetCost, "magnet") }
        spawn { Listen(BuyRewind, RewindCost, "rewind") }

    Listen(Button : button_device, Cost : int, Kind : string)<suspends> : void =
        loop:
            OptAgent := Button.InteractedWithEvent.Await()
            if (Agent := OptAgent?):
                if (Coins.TrySpend(Agent, Cost)):
                    GrantConsumable(Agent, Kind)
                    Feedback.Show(Agent)
                else:
                    Print("Sense fitxes per {Kind}.")

    # Marca que el jugador té el potenciador disponible.
    # L'efecte real (impuls, hover, imant, rebobinar) es cabla a UEFN amb el
    # dispositiu corresponent i s'activa quan el jugador el fa servir.
    GrantConsumable(Agent : agent, Kind : string) : void =
        Print("Potenciador concedit: {Kind}")
