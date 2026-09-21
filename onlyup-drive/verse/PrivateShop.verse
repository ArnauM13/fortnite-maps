using { /Fortnite.com/Devices }
using { /Fortnite.com/Characters }
using { /Fortnite.com/Game }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

# BOTIGA PRIVADA (personal, per jugador).
# Cada jugador té el SEU inventari de compres persistents. Gasta KM (meta_progress).
# Pensada per a cosmètics i desbloquejos permanents del garatge del jugador:
# rastres de neó, skins de cotxe-trofeu, emotes, colors d'underglow, vehicle d'entrada.
# Les compres es guarden per compte i NO afecten els altres jugadors.

private_shop_save := class<final>():
    var Owned : [string]logic = map{}   # id d'article -> comprat

var ShopSaves : weak_map(player, private_shop_save) = map{}

private_shop := class(creative_device):

    @editable Meta : meta_progress = meta_progress{}
    @editable Feedback : hud_message_device = hud_message_device{}

    # Botons de la botiga (afegeix els que vulguis). id + cost en KM.
    @editable BuyTrailPink : button_device = button_device{}
    @editable BuyTrailCyan : button_device = button_device{}
    @editable BuyTrophySkin : button_device = button_device{}
    @editable BuyEntranceCar : button_device = button_device{}
    @editable BuySummitEmote : button_device = button_device{}

    OnBegin<override>()<suspends> : void =
        spawn { Listen(BuyTrailPink, "trail_pink", 60) }
        spawn { Listen(BuyTrailCyan, "trail_cyan", 60) }
        spawn { Listen(BuyTrophySkin, "trophy_skin", 120) }
        spawn { Listen(BuyEntranceCar, "entrance_car", 100) }
        spawn { Listen(BuySummitEmote, "summit_emote", 80) }

    Listen(Button : button_device, Id : string, Cost : int)<suspends> : void =
        loop:
            OptAgent := Button.InteractedWithEvent.Await()
            if (Player := player[OptAgent?]):
                TryBuy(Player, Id, Cost)

    TryBuy(Player : player, Id : string, Cost : int) : void =
        S := GetSave(Player)
        if (AlreadyOwned(S, Id)):
            Print("Ja tens {Id}.")
            Feedback.Show(Player)
        else if (Meta.TrySpendKM(Player, Cost)):
            if (set S.Owned[Id] = true):
                Feedback.Show(Player)
                # A UEFN: activa aquí l'efecte cosmètic per a AQUEST jugador
                # (rastre, skin, emote...). No toca els altres.
                Print("Comprat (privat): {Id} per {Cost} KM")
        else:
            Print("Sense KM per {Id}.")

    AlreadyOwned(S : private_shop_save, Id : string) : logic =
        if (V := S.Owned[Id], V?):
            return true
        return false

    HasItem(Player : player, Id : string) : logic =
        AlreadyOwned(GetSave(Player), Id)

    GetSave(Player : player) : private_shop_save =
        if (S := ShopSaves[Player]):
            return S
        New := private_shop_save{}
        if (set ShopSaves[Player] = New) {}
        return New
