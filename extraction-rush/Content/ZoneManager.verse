using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

# ZoneManager
# Defineix els 3 anells de perill del mapa (Ravals, Centre, La Bòveda)
# i controla la tempesta que els va tancant de fora cap a dins.
# Cada zona té un nivell de perill i un nivell de loot associat (usat pel LootManager).

zone_manager := class(creative_device):

    # Controlador de tempesta de UEFN (fa el "shrink" de la zona jugable)
    @editable Storm : storm_controller_device = storm_controller_device{}

    # Mutator zones que marquen cada anell (per bonus loot / efectes)
    @editable OuterRingZone : mutator_zone_device = mutator_zone_device{}   # Zona 1 — Ravals
    @editable MidRingZone : mutator_zone_device = mutator_zone_device{}     # Zona 2 — Centre
    @editable VaultZone : mutator_zone_device = mutator_zone_device{}       # Zona 3 — Bòveda

    # HUD d'avís de tempesta
    @editable StormHUD : hud_message_device = hud_message_device{}

    # --- Estat intern ---
    var StormActive : logic = false

    # Nivells de perill per zona (1=baix, 3=mitjà, 5=alt) — informatiu per altres sistemes
    ZoneDanger : []int = array{1, 3, 5}
    ZoneNames : []string = array{"Ravals", "Centre", "La Bòveda"}

    OnBegin<override>()<suspends> : void =
        # Assegurar que la tempesta comença aturada durant el Deploy
        Storm.Disable()

    # Comença a tancar la zona — cridat pel GameManager a la fase de Tancament
    StartStorm() : void =
        if (not StormActive?):
            set StormActive = true
            Storm.Enable()
            Storm.GenerateStorm()
            Print("ZoneManager: Tempesta activada — la zona es tanca")

    # Accelera la tempesta a la fase d'extracció final
    AccelerateStorm() : void =
        Storm.GenerateStorm()
        Print("ZoneManager: Tempesta accelerada — extracció final")

    # Retorna el nivell de perill d'una zona (1..3)
    GetZoneDanger(ZoneIndex : int) : int =
        if (Danger := ZoneDanger[ZoneIndex]):
            return Danger
        return 1

    # Retorna el nom d'una zona
    GetZoneName(ZoneIndex : int) : string =
        if (Name := ZoneNames[ZoneIndex]):
            return Name
        return "Desconeguda"
