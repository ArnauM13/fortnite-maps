using { /Fortnite.com/Devices }
using { /Fortnite.com/Characters }
using { /Fortnite.com/Game }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

# RECOMPENSES PER TEMPS — degoteig per minuts jugats en la sessió actual.
# Cada fita de temps dona KM i mostra un avís ("Portes 10 min! +20 KM").
# Reforça "quedar-se una mica més". Veure retention.md / progression.md.
session_rewards := class(creative_device):

    @editable Meta : meta_progress = meta_progress{}
    @editable RewardHUD : hud_message_device = hud_message_device{}
    @editable CheckInterval : float = 60.0   # comprova cada minut

    # Minuts als quals es dona recompensa i quants KM.
    RewardMinutes : []int = array{5, 10, 15, 20, 30, 45, 60}
    RewardKM : []int = array{10, 20, 30, 40, 60, 80, 120}

    # Minuts acumulats i quina fita ja s'ha donat, per jugador.
    var Minutes : [agent]int = map{}
    var NextIndex : [agent]int = map{}

    OnBegin<override>()<suspends> : void =
        loop:
            Sleep(CheckInterval)
            for (Player : GetPlayspace().GetPlayers()):
                Tick(Player)

    Tick(Player : player) : void =
        Mins := GetMinutes(Player) + 1
        if (set Minutes[Player] = Mins) {}
        Idx := GetNext(Player)
        if (Target := RewardMinutes[Idx], Mins >= Target, KM := RewardKM[Idx]):
            Meta.AwardKM(Player, KM)
            RewardHUD.Show(Player)
            if (set NextIndex[Player] = Idx + 1) {}
            Print("Recompensa de temps: {Target} min → +{KM} KM")

    GetMinutes(Agent : agent) : int =
        if (M := Minutes[Agent]):
            return M
        return 0

    GetNext(Agent : agent) : int =
        if (N := NextIndex[Agent]):
            return N
        return 0
