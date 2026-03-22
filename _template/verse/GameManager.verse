using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

# GameManager — Plantilla base per nou mapa
# Substitueix [MAP_NAME] pel nom del teu mapa

map_game_manager := class(creative_device):

    OnBegin<override>()<suspends> : void =
        Print("[MAP_NAME] — Partida iniciada")
        # TODO: implementar lògica del mapa
