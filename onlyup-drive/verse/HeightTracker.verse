using { /Fortnite.com/Devices }
using { /Fortnite.com/Characters }
using { /Fortnite.com/Game }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

# Segueix per quina secció va cada jugador i la millor alçada assolida.
# Els triggers d'entrada de secció es col·loquen al principi de cada franja (veure build-layout.md §1).
height_tracker := class(creative_device):

    @editable SectionTriggers : []trigger_device = array{}
    @editable HeightHUD : hud_message_device = hud_message_device{}
    @editable Coins : coin_manager = coin_manager{}
    @editable Daily : daily_challenge_manager = daily_challenge_manager{}
    @editable AnnounceOnSection : logic = true
    @editable SectionCoinBonus : int = 3

    # Alçada (Z) representativa de cada secció, en el mateix ordre que SectionTriggers.
    SectionHeights : []int = array{0, 500, 1200, 2000, 2700, 3300, 4000}
    SectionNames : []string =
        array{"Estacio de Servei", "L'Embus", "Els Ponts", "L'Autocinema",
              "El Tunel", "El Nus", "Cim del Sol"}

    var BestHeight : int = 0
    var CurrentSection : int = 0

    OnBegin<override>()<suspends> : void =
        for (Index -> Trig : SectionTriggers):
            spawn { ListenSection(Trig, Index) }

    ListenSection(Trig : trigger_device, Index : int)<suspends> : void =
        loop:
            OptAgent := Trig.TriggeredEvent.Await()
            if (Agent := OptAgent?):
                OnSectionEntered(Index, Agent)

    OnSectionEntered(Index : int, Agent : agent) : void =
        # Només premia AVANÇAR (secció nova), no anar i tornar.
        if (Index > CurrentSection):
            set CurrentSection = Index
            # Bonus de fitxes per secció nova + puja la ratxa "sense caure".
            Coins.AwardSectionBonus(Agent, SectionCoinBonus)
            Coins.IncreaseStreak(Agent)
            # Progrés de reptes diaris ("arriba a la secció N").
            if (P := player[Agent]):
                Daily.ReportProgress(P, challenge_kind.ReachSection, Index + 1)
        if (H := SectionHeights[Index], H > BestHeight):
            set BestHeight = H
        if (AnnounceOnSection?, Name := SectionNames[Index]):
            HeightHUD.Show(Agent)
            Print("Seccio {Index}: {Name} — alçada {BestHeight}m")

    GetBestHeight() : int = BestHeight

    GetCurrentSection() : int = CurrentSection
