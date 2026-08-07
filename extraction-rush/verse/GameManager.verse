using { /Fortnite.com/Devices }
using { /Fortnite.com/Characters }
using { /Fortnite.com/Game }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

# GameManager
# Orquestra tots els sistemes d'EXTRACTION RUSH durant una ronda.
# Reacciona als canvis de fase del RaidTimer per obrir extraccions i moure la tempesta,
# i connecta les morts (perdre botí) amb l'inventari.
#
# Estats: Waiting → Deploy → Raid → Closing → FinalExtraction → Ended

game_manager := class(creative_device):

    # --- Referències als altres sistemes (assignar al UEFN editor) ---
    @editable Timer : raid_timer = raid_timer{}
    @editable Zones : zone_manager = zone_manager{}
    @editable Loot : loot_manager = loot_manager{}
    @editable Extraction : extraction_controller = extraction_controller{}
    @editable Inventory : inventory_manager = inventory_manager{}
    @editable Missions : mission_manager = mission_manager{}

    # Gestor d'eliminacions (per detectar morts i perdre el botí de ronda)
    @editable EliminationManager : elimination_manager_device = elimination_manager_device{}

    # HUD de compte enrere previ al deploy
    @editable CountdownHUD : hud_message_device = hud_message_device{}

    OnBegin<override>()<suspends> : void =
        Print("EXTRACTION RUSH — Esperant jugadors...")

        # Compte enrere abans del deploy
        Sleep(3.0)
        StartRound()

        # Escoltar fases i morts en paral·lel durant tota la ronda
        race:
            PhaseLoop()
            EliminationLoop()

    # Inicia la ronda i genera el loot inicial
    StartRound() : void =
        Print("EXTRACTION RUSH — Ronda iniciada!")
        Loot.SpawnInitialLoot()
        Timer.StartRound()
        spawn { Loot.StartRestockTimer() }

    # Reacciona a cada canvi de fase del RaidTimer
    PhaseLoop()<suspends> : void =
        loop:
            let Phase := Timer.PhaseChangedEvent.Await()
            OnPhaseChanged(Phase)
            if (Phase = raid_phase.Ended):
                break

    # Aplica els efectes de cada fase
    OnPhaseChanged(Phase : raid_phase) : void =
        case (Phase):
            raid_phase.Deploy =>
                Print("Fase: DEPLOY — immunitat inicial")
            raid_phase.Raid =>
                Print("Fase: RAID — extraccions ràpides obertes")
                Extraction.OpenQuickExtractions()
            raid_phase.Closing =>
                Print("Fase: TANCAMENT — tempesta activa, extracció central")
                Zones.StartStorm()
                Extraction.SwitchToCentral()
            raid_phase.FinalExtraction =>
                Print("Fase: EXTRACCIÓ FINAL — tempesta accelerada")
                Zones.AccelerateStorm()
            raid_phase.Ended =>
                Print("Fase: FI — ronda acabada")
                Extraction.CloseAll()
                EndRound()

    # Escolta les eliminacions: qui mor perd tot el botí de la ronda,
    # qui elimina rep XP.
    EliminationLoop()<suspends> : void =
        loop:
            let Payload := EliminationManager.EliminatedEvent.Await()

            # El jugador eliminat perd el botí de ronda
            if (Victim := player[Payload.EliminatedCharacter.GetAgent[]]):
                Inventory.LoseRunLoot(Victim)

            # L'eliminador (si és jugador) rep XP
            if:
                InstigatorAgent := Payload.EliminatingCharacter?.GetAgent[]
                Killer := player[InstigatorAgent]
            then:
                Missions.RegisterElimination(Killer)

    # Neteja de final de ronda
    EndRound() : void =
        Print("EXTRACTION RUSH — Resultats. Els supervivents conserven el botí.")
        Timer.StopRound()
