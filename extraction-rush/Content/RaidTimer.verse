using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

# RaidTimer
# Controla el temps total de la ronda i les seves fases:
#   Deploy → Raid → Tancament → Extracció final → Fi
# Notifica els altres sistemes quan canvia de fase (obrir extraccions, moure tempesta).

# Fases de la ronda
raid_phase := enum:
    Deploy
    Raid
    Closing
    FinalExtraction
    Ended

raid_timer := class(creative_device):

    # HUD principal amb el temps restant de la ronda
    @editable TimerHUD : hud_message_device = hud_message_device{}

    # HUD d'avís de canvi de fase (tempesta, extraccions)
    @editable PhaseHUD : hud_message_device = hud_message_device{}

    # Durada total de la ronda en segons (per defecte 8 min)
    @editable RoundDurationSeconds : int = 480

    # Segons en què comença cada fase (des de l'inici)
    @editable DeployEndSeconds : int = 20        # Deploy: 0–20s
    @editable ClosingStartSeconds : int = 300    # Tancament: 5:00
    @editable FinalStartSeconds : int = 420      # Extracció final: 7:00

    # --- Estat intern ---
    var IsRunning : logic = false
    var ElapsedSeconds : int = 0
    var CurrentPhase : raid_phase = raid_phase.Deploy

    # Esdeveniment que altres sistemes poden escoltar per reaccionar a les fases
    PhaseChangedEvent : event(raid_phase) = event(raid_phase){}

    # Inicia la ronda — cridat pel GameManager
    StartRound() : void =
        set IsRunning = true
        set ElapsedSeconds = 0
        set CurrentPhase = raid_phase.Deploy
        Print("RaidTimer: Ronda iniciada — fase Deploy")
        spawn { TimerLoop() }

    # Atura la ronda (final o buida)
    StopRound() : void =
        set IsRunning = false
        set CurrentPhase = raid_phase.Ended
        PhaseChangedEvent.Signal(raid_phase.Ended)

    GetRemainingSeconds() : int = RoundDurationSeconds - ElapsedSeconds
    GetCurrentPhase() : raid_phase = CurrentPhase

    # Retorna el temps restant formatat "MM:SS"
    GetFormattedRemaining() : string =
        Remaining : int = GetRemainingSeconds()
        Minutes : int = Remaining / 60
        Seconds : int = Remaining - (Minutes * 60)
        MinStr : string = if (Minutes < 10) then "0{Minutes}" else "{Minutes}"
        SecStr : string = if (Seconds < 10) then "0{Seconds}" else "{Seconds}"
        return "{MinStr}:{SecStr}"

    # Bucle principal: cada segon actualitza el temps i comprova canvis de fase
    TimerLoop()<suspends> : void =
        loop:
            if (not IsRunning):
                break
            if (ElapsedSeconds >= RoundDurationSeconds):
                Print("RaidTimer: Temps esgotat")
                StopRound()
                break

            Sleep(1.0)
            set ElapsedSeconds = ElapsedSeconds + 1
            UpdatePhase()
            Print("RaidTimer | {GetFormattedRemaining()} | fase {CurrentPhase}")

    # Comprova si toca canviar de fase segons el temps transcorregut
    UpdatePhase() : void =
        var NewPhase : raid_phase = CurrentPhase

        if (ElapsedSeconds >= FinalStartSeconds):
            set NewPhase = raid_phase.FinalExtraction
        else if (ElapsedSeconds >= ClosingStartSeconds):
            set NewPhase = raid_phase.Closing
        else if (ElapsedSeconds >= DeployEndSeconds):
            set NewPhase = raid_phase.Raid

        if (NewPhase <> CurrentPhase):
            set CurrentPhase = NewPhase
            Print("RaidTimer: Nova fase → {NewPhase}")
            PhaseChangedEvent.Signal(NewPhase)
