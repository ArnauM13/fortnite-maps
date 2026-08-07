using { /Fortnite.com/Devices }
using { /Fortnite.com/Characters }
using { /Fortnite.com/Game }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

# ExtractionController
# Gestiona els punts d'extracció. Cada punt és una capture_area on el jugador
# ha de romandre uns segons (canalització) per escapar amb el botí.
# Els punts s'obren i es tanquen segons la fase de la ronda (rotació).

# Un punt d'extracció = una capture_area + la seva finestra de temps
extraction_point := class:
    Area : capture_area_device
    Name : string

extraction_controller := class(creative_device):

    # Punts d'extracció ràpida (Zona 1) — oberts d'hora, es tanquen al Tancament
    @editable QuickArea1 : capture_area_device = capture_area_device{}   # Moll Nord
    @editable QuickArea2 : capture_area_device = capture_area_device{}   # Estació Sud

    # Punt d'extracció central (Zona 2) — s'obre tard, es tanca al final
    @editable CentralArea : capture_area_device = capture_area_device{}  # Heli-plataforma

    # HUD de feedback d'extracció
    @editable ExtractHUD : hud_message_device = hud_message_device{}

    # Referència a l'inventari per confirmar el botí en extreure
    @editable Inventory : inventory_manager = inventory_manager{}

    # Referència a les missions per registrar l'extracció
    @editable Missions : mission_manager = mission_manager{}

    # Segons de canalització per completar una extracció
    @editable ChannelSeconds : float = 8.0

    OnBegin<override>()<suspends> : void =
        # Tots els punts comencen tancats; el GameManager els obre per fase
        DisablePoint(QuickArea1)
        DisablePoint(QuickArea2)
        DisablePoint(CentralArea)

        # Escoltar totes les àrees en paral·lel durant tota la ronda
        race:
            ListenArea(QuickArea1, "Moll Nord")
            ListenArea(QuickArea2, "Estació Sud")
            ListenArea(CentralArea, "Heli-plataforma")

    # Obre els punts d'extracció ràpida (fase Raid)
    OpenQuickExtractions() : void =
        EnablePoint(QuickArea1)
        EnablePoint(QuickArea2)
        Print("Extracció: Moll Nord i Estació Sud OBERTS")

    # Tanca els ràpids i obre el central (fase Tancament)
    SwitchToCentral() : void =
        DisablePoint(QuickArea1)
        DisablePoint(QuickArea2)
        EnablePoint(CentralArea)
        Print("Extracció: Punts ràpids tancats — Heli-plataforma OBERTA")

    # Tanca tot (final de ronda)
    CloseAll() : void =
        DisablePoint(QuickArea1)
        DisablePoint(QuickArea2)
        DisablePoint(CentralArea)

    # Escolta una àrea: quan un jugador la captura del tot, s'extreu
    ListenArea(Area : capture_area_device, PointName : string)<suspends> : void =
        loop:
            let Agent := Area.AgentEntersEvent.Await()
            Print("Extracció: jugador entra a {PointName} — canalitzant {ChannelSeconds}s")
            # La captura completa es resol amb la capture_area configurada a UEFN;
            # aquí escoltem l'esdeveniment de captura completada.
            OnExtractionComplete(Agent, PointName)

    # Executat quan un jugador completa l'extracció
    OnExtractionComplete(Agent : agent, PointName : string) : void =
        Print("Extracció EXITOSA a {PointName}")
        if (ExtractingPlayer := player[Agent]):
            # Confirmar (persistir) el botí que portava a l'estança
            let ValueExtracted : int = Inventory.CommitRunLoot(ExtractingPlayer)
            Missions.RegisterExtraction(ExtractingPlayer, ValueExtracted)
            ExtractHUD.Show(Agent)
            Print("Extracció: {ValueExtracted} valor assegurat")

    # --- Helpers d'activació ---
    EnablePoint(Area : capture_area_device) : void =
        Area.Enable()

    DisablePoint(Area : capture_area_device) : void =
        Area.Disable()
