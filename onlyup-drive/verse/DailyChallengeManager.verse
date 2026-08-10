using { /Fortnite.com/Devices }
using { /Fortnite.com/Characters }
using { /Fortnite.com/Game }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

# Reptes diaris (3 rotatius). Donen KM en completar-se. Veure retention.md.
# La rotació diària real es gestiona amb la data/hora del servidor; aquí en portem
# la lògica de progrés dins la sessió i deleguem la persistència a MetaProgress.

challenge_kind := enum:
    ReachSection      # arribar a la secció N
    CollectCoins      # recollir N fitxes en un intent
    PureClear         # clear sense comprar checkpoints
    HoldStreak        # mantenir ratxa x2 durant N segons
    FindSecrets       # trobar N secretes
    SpeedClear        # clear en menys de N segons

daily_challenge_manager := class(creative_device):

    @editable Meta : meta_progress = meta_progress{}
    @editable Coins : coin_manager = coin_manager{}
    @editable Heights : height_tracker = height_tracker{}
    @editable ChallengeHUD : hud_message_device = hud_message_device{}
    @editable KMPerChallenge : int = 30

    # Els 3 reptes actius d'avui i el seu objectiu numèric.
    @editable ActiveA : challenge_kind = challenge_kind.ReachSection
    @editable TargetA : int = 4
    @editable ActiveB : challenge_kind = challenge_kind.CollectCoins
    @editable TargetB : int = 40
    @editable ActiveC : challenge_kind = challenge_kind.PureClear
    @editable TargetC : int = 1

    # Marca de completat per jugador i repte (0=A,1=B,2=C).
    var Completed : [agent]int = map{}

    # Cridat pels sistemes quan passa alguna cosa rellevant.
    # Exemple: en entrar a una secció, GameManager/HeightTracker crida
    # ReportProgress(Agent, challenge_kind.ReachSection, SectionIndex).
    ReportProgress(Player : player, Kind : challenge_kind, Value : int) : void =
        CheckAndReward(Player, 0, ActiveA, TargetA, Kind, Value)
        CheckAndReward(Player, 1, ActiveB, TargetB, Kind, Value)
        CheckAndReward(Player, 2, ActiveC, TargetC, Kind, Value)

    CheckAndReward(
        Player : player, Slot : int,
        Active : challenge_kind, Target : int,
        Kind : challenge_kind, Value : int
    ) : void =
        # NOTA: SpeedClear s'assoleix quan Value <= Target (menys temps = millor).
        # La resta de reptes són "assolir com a mínim Target". Ajusta aquí si
        # afegeixes reptes de tipus "menys que".
        Met := if (Kind = challenge_kind.SpeedClear) then Value <= Target else Value >= Target
        if (Active = Kind, Met?, not IsDone(Player, Slot)):
            MarkDone(Player, Slot)
            Meta.AwardKM(Player, KMPerChallenge)
            ChallengeHUD.Show(Player)
            Print("Repte diari completat (slot {Slot}) +{KMPerChallenge} KM")

    IsDone(Agent : agent, Slot : int) : logic =
        if (Mask := Completed[Agent]):
            # bit Slot activat?
            return Mod[Mask / Pow(2, Slot), 2] = 1
        return false

    MarkDone(Agent : agent, Slot : int) : void =
        Mask := if (M := Completed[Agent]) then M else 0
        if (not IsDone(Agent, Slot), set Completed[Agent] = Mask + Pow(2, Slot)) {}

    # helper enter (2^n) sense dependre de la lib de mates
    Pow(Base : int, Exp : int) : int =
        var Result : int = 1
        var I : int = 0
        loop:
            if (I >= Exp) { break }
            set Result = Result * Base
            set I = I + 1
        Result
