using { /Fortnite.com/Devices }
using { /Fortnite.com/Characters }
using { /Fortnite.com/Game }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

# NIVELL DE CONDUCTOR — XP per temps jugat + fites → nivells → Punts de Garatge.
# Persistent per compte. Emet el degoteig "+1" i les recompenses de nivell.
# Veure progression.md.

driver_save := class<final>():
    var XP : int = 0
    var Level : int = 1
    var Points : int = 0       # Punts de Garatge disponibles

var DriverSaves : weak_map(player, driver_save) = map{}

driver_level := class(creative_device):

    @editable Meta : meta_progress = meta_progress{}
    @editable LevelHUD : hud_message_device = hud_message_device{}
    @editable XPTickSeconds : float = 10.0   # +1 XP per temps viu
    @editable KMPerLevel : int = 15

    OnBegin<override>()<suspends> : void =
        loop:
            Sleep(XPTickSeconds)
            for (Player : GetPlayspace().GetPlayers()):
                AddXP(Player, 1)   # degoteig passiu per temps

    # Cridat pels altres sistemes (monedes, seccions, cim, rècords).
    AddXP(Player : player, Amount : int) : void =
        S := GetSave(Player)
        set S.XP += Amount
        CheckLevelUp(Player, S)

    CheckLevelUp(Player : player, S : driver_save) : void =
        loop:
            Need := 100 * S.Level
            if (S.XP >= Need):
                set S.XP -= Need
                set S.Level += 1
                set S.Points += 1
                Meta.AwardKM(Player, KMPerLevel)
                LevelHUD.Show(Player)
                Print("NIVELL {S.Level}! +1 Punt de Garatge, +{KMPerLevel} KM")
            else:
                break

    # Gasta un Punt de Garatge (cridat per GarageUpgrades). Retorna true si n'hi havia.
    TrySpendPoint(Player : player) : logic =
        S := GetSave(Player)
        if (S.Points >= 1):
            set S.Points -= 1
            return true
        return false

    GetLevel(Player : player) : int = GetSave(Player).Level
    GetPoints(Player : player) : int = GetSave(Player).Points

    # Títol segons el nivell (per al HUD/perfil).
    GetTitle(Player : player) : string =
        L := GetSave(Player).Level
        if (L >= 35) then "Fantasma de l'Autopista"
        else if (L >= 20) then "Llegenda Outrun"
        else if (L >= 10) then "Corredor Nocturn"
        else if (L >= 5) then "Repartidor"
        else "Aprenent"

    GetSave(Player : player) : driver_save =
        if (S := DriverSaves[Player]):
            return S
        New := driver_save{}
        if (set DriverSaves[Player] = New) {}
        return New
