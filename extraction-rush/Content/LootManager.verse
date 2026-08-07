using { /Fortnite.com/Devices }
using { /Fortnite.com/Characters }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

# LootManager
# Controla els spawns de loot per nivell de raresa:
#   Zona 1 → comú (verd) · Zona 2 → poc comú (morat) · Zona 3 → èpic/daurat
# Cada item_spawner es dispara al principi de la ronda i, opcionalment,
# es reomple ("restock") un cop a meitat de ronda per mantenir el flux.

loot_manager := class(creative_device):

    # Spawners de loot per nivell (assignar-ne tants com calgui al UEFN editor)
    @editable CommonSpawners : []item_spawner_device = array{}   # Zona 1 — verd
    @editable RareSpawners : []item_spawner_device = array{}     # Zona 2 — morat
    @editable EpicSpawners : []item_spawner_device = array{}     # Zona 3 — daurat

    # Objecte de valor especial de La Bòveda (clau daurada / artefacte)
    @editable VaultRewardSpawner : item_spawner_device = item_spawner_device{}

    # Segons després de l'inici en què es fa el "restock" de loot comú/rar
    @editable RestockAtSeconds : float = 180.0

    # --- Estat intern ---
    var HasRestocked : logic = false

    # Genera tot el loot inicial — cridat pel GameManager a l'inici de la ronda
    SpawnInitialLoot() : void =
        Print("LootManager: Generant loot inicial")
        SpawnAll(CommonSpawners)
        SpawnAll(RareSpawners)
        SpawnAll(EpicSpawners)
        VaultRewardSpawner.SpawnItem()

    # Reomple el loot comú i rar a meitat de ronda (mantenir el flux de looting)
    StartRestockTimer()<suspends> : void =
        Sleep(RestockAtSeconds)
        if (not HasRestocked?):
            set HasRestocked = true
            Print("LootManager: Restock de loot")
            SpawnAll(CommonSpawners)
            SpawnAll(RareSpawners)

    # Dispara tots els spawners d'una llista
    SpawnAll(Spawners : []item_spawner_device) : void =
        for (Spawner : Spawners):
            Spawner.SpawnItem()
