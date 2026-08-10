using { /Fortnite.com/Devices }
using { /Fortnite.com/Characters }
using { /Fortnite.com/Game }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

# KM (🏁) — moneda PERSISTENT entre partides.
# Es calcula en acabar cada intent i es guarda per compte amb `weak_map` persistent.
# Es gasta a la botiga del hub (cosmètics + perks lleus). Veure economy.md / retention.md.

# Estat persistent per jugador (persisteix entre sessions).
meta_save := class<final>():
    var TotalKM : int = 0
    var BestHeight : int = 0
    var BestTimeSeconds : int = 0
    var HasClearedEver : logic = false
    var HasClearedPure : logic = false

var PlayerSaves : weak_map(player, meta_save) = map{}

meta_progress := class(creative_device):

    @editable KMHUD : hud_message_device = hud_message_device{}

    # Càlcul de KM en acabar un intent. Cridat per GameManager en caure/sortir o al cim.
    AwardEndOfRun(
        Player : player,
        MaxHeight : int,
        ReachedSummit : logic,
        BoughtCheckpoint : logic,
        AllCoins : logic,
        TimeSeconds : int
    ) : void =
        Save := GetSave(Player)
        var Gained : int = MaxHeight / 100

        NewHeightPB := MaxHeight > Save.BestHeight
        if (NewHeightPB):
            set Save.BestHeight = MaxHeight
            set Gained += 25

        if (ReachedSummit?):
            if (not Save.HasClearedEver?):
                set Save.HasClearedEver = true
                set Gained += 100
            if (not BoughtCheckpoint?, not Save.HasClearedPure?):
                set Save.HasClearedPure = true
                set Gained += 75
            if (AllCoins?):
                set Gained += 50
            if (Save.BestTimeSeconds = 0 or TimeSeconds < Save.BestTimeSeconds):
                set Save.BestTimeSeconds = TimeSeconds
                set Gained += 25

        set Save.TotalKM += Gained
        KMHUD.Show(Player)
        Print("KM guanyats: {Gained} (total {Save.TotalKM})")

    # Recompensa la primera escalada del dia i els reptes (cridat per DailyChallengeManager).
    AwardKM(Player : player, Amount : int) : void =
        Save := GetSave(Player)
        set Save.TotalKM += Amount
        KMHUD.Show(Player)

    # Intent de compra al hub. Retorna true si hi ha prou KM.
    TrySpendKM(Player : player, Cost : int) : logic =
        Save := GetSave(Player)
        if (Save.TotalKM >= Cost):
            set Save.TotalKM -= Cost
            return true
        return false

    GetSave(Player : player) : meta_save =
        if (S := PlayerSaves[Player]):
            return S
        NewSave := meta_save{}
        if (set PlayerSaves[Player] = NewSave) {}
        return NewSave
