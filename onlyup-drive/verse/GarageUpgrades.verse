using { /Fortnite.com/Devices }
using { /Fortnite.com/Characters }
using { /Fortnite.com/Game }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

# EL GARATGE — millores incrementals "+1" per jugador (persistents).
# Cada node puja +1 per nivell amb topall. Exposa getters que altres sistemes
# consulten (velocitat, imant, multiplicador, descompte). Veure progression.md.

garage_save := class<final>():
    var Motor : int = 0        # màx 5  → +2% velocitat/nivell
    var Nitro : int = 0        # màx 3  → +1 càrrega/nivell
    var Suspensio : int = 0    # màx 3  → +0.1s marge/nivell
    var Diposit : int = 0      # màx 3  → -2 cost checkpoint/nivell
    var Iman : int = 0         # màx 4  → +75 radi/nivell
    var TurboCaixa : int = 0   # màx 5  → +10% guanys/nivell
    var Prestigi : int = 0     # ∞      → +25% global/nivell

var GarageSaves : weak_map(player, garage_save) = map{}

garage_upgrades := class(creative_device):

    @editable Level : driver_level = driver_level{}
    @editable Feedback : hud_message_device = hud_message_device{}

    # Botons de millora (un per node). Cada compra gasta 1 Punt de Garatge.
    @editable BuyMotor : button_device = button_device{}
    @editable BuyNitro : button_device = button_device{}
    @editable BuySuspensio : button_device = button_device{}
    @editable BuyDiposit : button_device = button_device{}
    @editable BuyIman : button_device = button_device{}
    @editable BuyTurboCaixa : button_device = button_device{}
    @editable BuyPrestigi : button_device = button_device{}

    OnBegin<override>()<suspends> : void =
        spawn { Listen(BuyMotor, "motor", 5) }
        spawn { Listen(BuyNitro, "nitro", 3) }
        spawn { Listen(BuySuspensio, "suspensio", 3) }
        spawn { Listen(BuyDiposit, "diposit", 3) }
        spawn { Listen(BuyIman, "iman", 4) }
        spawn { Listen(BuyTurboCaixa, "turbo", 5) }
        spawn { Listen(BuyPrestigi, "prestigi", 9999) }

    Listen(Button : button_device, Node : string, Cap : int)<suspends> : void =
        loop:
            OptAgent := Button.InteractedWithEvent.Await()
            if (Player := player[OptAgent?]):
                TryUpgrade(Player, Node, Cap)

    TryUpgrade(Player : player, Node : string, Cap : int) : void =
        S := GetSave(Player)
        Current := NodeValue(S, Node)
        if (Current < Cap, Level.TrySpendPoint(Player)):
            SetNode(S, Node, Current + 1)
            Feedback.Show(Player)
            Print("Garatge +1: {Node} → {Current + 1}")
        else:
            Print("Garatge: {Node} al màxim o sense punts.")

    # --- Getters que consulten els altres sistemes ---

    # Bonus de velocitat en % (0..10). Ignora'l si el jugador va en "Sortida Neta".
    GetMoveSpeedBonus(Player : player) : int = GetSave(Player).Motor * 2 * GlobalMult(Player) / 100

    GetMagnetRadius(Player : player) : int = GetSave(Player).Iman * 75 * GlobalMult(Player) / 100

    # Multiplicador de guanys en % (100 = x1). TurboCaixa + prestigi.
    GetEarnMultiplier(Player : player) : int =
        Base := 100 + GetSave(Player).TurboCaixa * 10
        Base * GlobalMult(Player) / 100

    GetCheckpointDiscount(Player : player) : int = GetSave(Player).Diposit * 2

    GetNitroCharges(Player : player) : int = GetSave(Player).Nitro

    # Multiplicador global del prestigi (100 = x1, +25 per nivell de prestigi).
    GlobalMult(Player : player) : int = 100 + GetSave(Player).Prestigi * 25

    # --- helpers de node ---
    NodeValue(S : garage_save, Node : string) : int =
        case (Node):
            "motor" => S.Motor
            "nitro" => S.Nitro
            "suspensio" => S.Suspensio
            "diposit" => S.Diposit
            "iman" => S.Iman
            "turbo" => S.TurboCaixa
            "prestigi" => S.Prestigi
            _ => 0

    SetNode(S : garage_save, Node : string, V : int) : void =
        case (Node):
            "motor" => set S.Motor = V
            "nitro" => set S.Nitro = V
            "suspensio" => set S.Suspensio = V
            "diposit" => set S.Diposit = V
            "iman" => set S.Iman = V
            "turbo" => set S.TurboCaixa = V
            "prestigi" =>
                # Prestigi: reinicia l'arbre i puja el multiplicador global.
                set S.Motor = 0
                set S.Nitro = 0
                set S.Suspensio = 0
                set S.Diposit = 0
                set S.Iman = 0
                set S.TurboCaixa = 0
                set S.Prestigi = V
            _ => {}

    GetSave(Player : player) : garage_save =
        if (S := GarageSaves[Player]):
            return S
        New := garage_save{}
        if (set GarageSaves[Player] = New) {}
        return New
