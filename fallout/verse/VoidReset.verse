using { /Fortnite.com/Devices }
using { /Fortnite.com/Characters }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

# VoidReset
# Substitueix el sistema de checkpoints d'un climber clàssic. Quan un jugador
# cau fora del mapa (toca el volum "void" de sota tot), el retorna al fons de
# la SECCIÓ on estava — no a l'inici absolut, i sense game over.
#
# Això manté la filosofia Only Up: caure fa mal (perds tota la secció), però
# segueixes competint per l'alçada.

void_reset := class(creative_device):

    # Volum gegant col·locat sota tot el mapa que detecta les caigudes.
    @editable VoidVolume : volume_device = volume_device{}

    # Un teletransport per secció, col·locat al "fons de secció" (lleixa de
    # rescat). Ordre de baix a dalt: [0] = fons secció 1, [1] = fons secció 2...
    @editable SectionBottoms : []teleporter_device = array{}

    # Llindars d'alçada (en unitats Unreal, Z) que separen les seccions.
    # Han de coincidir amb SectionBottoms: el jugador cau a la secció més alta
    # el llindar de la qual encara ha superat.
    @editable SectionThresholdsZ : []float = array{}

    # Escolta caigudes al void i reacciona.
    Start()<suspends> : void =
        Print("VoidReset — vigilant el void")
        loop:
            let Agent := VoidVolume.AgentEntersEvent.Await()
            if (Player := player[Agent]):
                ResetToSection(Player)

    # Teletransporta el jugador al fons de la secció que li correspon per alçada.
    ResetToSection(Player : player) : void =
        if (Character := Player.GetFortCharacter[]):
            let FallenZ : float = Character.GetTransform().Translation.Z
            let Index : int = SectionIndexForHeight(FallenZ)
            if (Teleporter := SectionBottoms[Index]):
                Teleporter.Teleport(Player)
                Print("Caiguda! Retorn al fons de la secció {Index + 1}")

    # Determina a quina secció pertany una alçada. Retorna l'índex més alt
    # el llindar del qual el jugador ja havia superat (mínim 0 = secció 1).
    SectionIndexForHeight(HeightZ : float) : int =
        var Result : int = 0
        for (I -> Threshold : SectionThresholdsZ):
            if (HeightZ >= Threshold):
                set Result = I
        return Result
