# EXTRACTION RUSH — Guia de muntatge a UEFN

Tot el que necessites per començar a construir el mapa a UEFN. El codi Verse ja
és a `Content/`; aquí tens com crear el projecte, compilar-lo i **col·locar i
cablejar cada dispositiu**.

> ⚠️ **Què NO hi ha en aquest repo (i per què).**
> Els fitxers binaris que defineixen el món — `Content/GameFeatureData.uasset`,
> el `.umap` de l'illa, els `__ExternalActors__`, meshes i materials — **els
> genera UEFN** quan crees el projecte. No es poden escriure a mà. Per això el
> flux comença creant el projecte a UEFN i després hi copies aquest Verse.

---

## Part 0 — Requisits

- UEFN instal·lat i sessió iniciada amb el teu compte d'Epic.
- Familiaritat bàsica amb el Verse Explorer i el Content Browser.
- Els fitxers `.verse` d'aquest repo (`extraction-rush/Content/`).

---

## Part 1 — Crear el projecte

**Opció A (recomanada): projecte nou a UEFN.**

1. UEFN → **Create Project** → plantilla **Blank** (o *Grid* per tenir terra).
2. Anomena'l `ExtractionRush`.
3. Quan obri, tanca'l un moment i **copia tots els `.verse` de
   `extraction-rush/Content/` dins la carpeta `Content/` del projecte** que
   UEFN t'ha creat (típicament `Documents/Fortnite Projects/ExtractionRush/Content/`).
4. Torna a obrir el projecte. Els scripts apareixeran al Verse Explorer.

> Els fitxers `ExtractionRush.uefnproject`, `.uplugin` i `.code-workspace`
> d'aquest repo són **plantilles de referència**. UEFN genera els seus propis amb
> els GUID i el `VersePath` correctes (`/EL_TEU_HANDLE@fortnite.com/ExtractionRush`).
> Si véns del Naufragi, el teu handle és `glicho` — ja el tens posat com a
> exemple. No cal que els facis servir; deixa que UEFN mani.

**Opció B: reutilitzar assets del Naufragi.**
Pots duplicar `OnlyUp_naufrago` com a punt de partida (ja té terra, materials de
colors i els devices de Verse compilant) i anar-hi afegint aquest Verse. Útil per
prototipar ràpid, però acabaràs substituint-ne la geometria.

---

## Part 2 — Compilar el Verse

1. Obre el **Verse Explorer** (Window → Verse Explorer).
2. **Build Verse Code** (o `Ctrl+Shift+B`).
3. Hauria de compilar. Si hi ha errors:
   - Els sistemes del **fonament** (v1) i els **reutilitzats del Naufragi** estan
     calcats de codi que ja compila — solen ser comes/indentació.
   - Els sistemes de l'**evolució v2** (`heat_system`, `squad_manager`,
     `beacon_manager`, `loadout_shop`) toquen APIs de dispositius que potser
     s'han d'ajustar a la teva versió d'UEFN (p. ex. mètodes de
     `map_indicator_device`, `vfx_creator_device`, moure props/triggers en
     runtime, camps d'`elimination_result`). Si un peta, comenta'l temporalment
     i munta primer el nucli jugable (Part 7).

Després de compilar, **cada `.verse` amb `class(creative_device)` apareix com a
dispositiu col·locable** al Content Browser (secció del teu projecte).

---

## Part 3 — Col·locar els dispositius Verse

Col·loca **una instància** de cadascun. Posa'ls tots junts en una plataforma de
lògica apartada del joc (no cal que siguin accessibles). **`shared_state` NO es
col·loca** — és només codi de mòdul compartit.

| Dispositiu Verse | Quantes | On |
|------------------|---------|----|
| `game_manager` | 1 | plataforma de lògica |
| `raid_timer` | 1 | plataforma de lògica |
| `zone_manager` | 1 | plataforma de lògica |
| `loot_manager` | 1 | plataforma de lògica |
| `extraction_controller` | 1 | plataforma de lògica |
| `inventory_manager` | 1 | plataforma de lògica |
| `mission_manager` | 1 | plataforma de lògica |
| `extraction_leaderboard` | 1 | prop dels billboards del lobby |
| `run_value_hud` | 1 | plataforma de lògica |
| `sea_reset_manager` | 1 | plataforma de lògica |
| `heat_system` | 1 | plataforma de lògica |
| `squad_manager` | 1 | plataforma de lògica |
| `beacon_manager` | 1 | plataforma de lògica |
| `loadout_shop` | 1 | al lobby, prop dels botons de compra |

---

## Part 4 — Dispositius natius a col·locar

Aquests són els dispositius d'Epic que els scripts controlen. Comptes orientatius
(ajusta segons la mida del mapa):

| Dispositiu natiu | Quants | Per a què |
|------------------|--------|-----------|
| `hud_message_device` | 1–11 | Feedback. Pots **reutilitzar-ne un** per a diversos slots o fer-ne un per sistema. |
| `storm_controller_device` | 1 | La tempesta que tanca la zona |
| `mutator_zone_device` | 3 | Marcar els 3 anells (Ravals / Centre / Bòveda) |
| `item_spawner_device` | ~10–30 | Loot: pools comú / rar / èpic + 1 recompensa de Bòveda |
| `capture_area_device` | 6 | 3 extraccions fixes + 3 per al pool de balises |
| `leaderboard_device` | 1 | Valor extret per ronda (natiu) |
| `billboard_device` | 3–5 | Rànquing d'estança al lobby |
| `trigger_device` | 7 | 1 zona de mar + 6 per al pool de bosses de botí |
| `elimination_manager_device` | 1 | Detectar morts |
| `creative_prop` | 9 | 6 props de bossa + 3 props de balisa (fum/llum) |
| `conditional_button_device` | 5 | 1 cridar balisa + 3 nivells de loadout + 1 assegurança |
| `item_granter_device` | 4 | 3 loadouts + 1 assegurança |
| `map_indicator_device` | ~1 per jugador o un grapat | Pings de Heat al minimapa |
| `vfx_creator_device` | grapat | Rastre visible de Heat roent |

---

## Part 5 — Cablejat dels `@editable` (device per device)

Selecciona cada dispositiu Verse i, al panell **Details**, assigna els seus camps.
"→ *X*" vol dir "apunta al dispositiu *X* que has col·locat".

### `game_manager`  (l'orquestrador)
| Camp | Assignació |
|------|-----------|
| Timer | → `raid_timer` |
| Zones | → `zone_manager` |
| Loot | → `loot_manager` |
| Extraction | → `extraction_controller` |
| CountdownHUD | → un `hud_message_device` |

### `raid_timer`
| Camp | Assignació / valor |
|------|-----------|
| TimerHUD | → `hud_message_device` |
| PhaseHUD | → `hud_message_device` |
| RoundDurationSeconds | 480 (8 min) |
| DeployEndSeconds | 20 |
| ClosingStartSeconds | 300 |
| FinalStartSeconds | 420 |

### `zone_manager`
| Camp | Assignació |
|------|-----------|
| Storm | → `storm_controller_device` |
| OuterRingZone | → `mutator_zone_device` (Ravals) |
| MidRingZone | → `mutator_zone_device` (Centre) |
| VaultZone | → `mutator_zone_device` (Bòveda) |
| StormHUD | → `hud_message_device` |

### `loot_manager`
| Camp | Assignació / valor |
|------|-----------|
| CommonSpawners | → llista d'`item_spawner_device` de la Zona 1 |
| RareSpawners | → llista d'`item_spawner_device` de la Zona 2 |
| EpicSpawners | → llista d'`item_spawner_device` de la Zona 3 |
| VaultRewardSpawner | → l'`item_spawner_device` de la recompensa de Bòveda |
| RestockAtSeconds | 180 |

> Als camps de **llista** (`[]item_spawner_device`, etc.) fes "+" i afegeix cada
> spawner un per un.

### `extraction_controller`
| Camp | Assignació / valor |
|------|-----------|
| QuickArea1 | → `capture_area_device` (Moll Nord, Zona 1) |
| QuickArea2 | → `capture_area_device` (Estació Sud, Zona 1) |
| CentralArea | → `capture_area_device` (Heli-plataforma, Zona 2) |
| ExtractHUD | → `hud_message_device` |
| Inventory | → `inventory_manager` |
| Missions | → `mission_manager` |
| ChannelSeconds | 8 |

### `inventory_manager`
| Camp | Assignació |
|------|-----------|
| ValueHUD | → `hud_message_device` |

### `mission_manager`
| Camp | Assignació / valor |
|------|-----------|
| MissionHUD | → `hud_message_device` |
| ValueLeaderboard | → `leaderboard_device` |
| XPPerLevel | 1000 |

### `extraction_leaderboard`
| Camp | Assignació / valor |
|------|-----------|
| Leaderboards | → llista de 3–5 `billboard_device` (index 0 = rang més alt) |
| RefreshIntervalSeconds | 5 |

### `run_value_hud`
Cap camp — funciona sol (mostra el valor 💠 en risc a la pantalla).

### `sea_reset_manager`
| Camp | Assignació / valor |
|------|-----------|
| SeaZone | → un `trigger_device` gran i pla sobre el mar, sota tot el mapa |
| RespawnHeightOffset | 100 |

### `heat_system`  (evolució v2)
| Camp | Assignació / valor |
|------|-----------|
| WarmThreshold / HotThreshold / BlazingThreshold | 100 / 300 / 600 |
| TickSeconds | 1 |
| HeatHUD | → `hud_message_device` |
| MapIndicators | → llista de `map_indicator_device` (un per jugador ideal) |
| BlazingVFX | → llista de `vfx_creator_device` |

### `squad_manager`  (evolució v2)
| Camp | Assignació |
|------|-----------|
| EliminationManager | → `elimination_manager_device` |
| BagProps | → llista de ~6 `creative_prop` (motxilla/caixa) |
| BagTriggers | → llista de ~6 `trigger_device` (mateixa mida que BagProps) |
| BagHUD | → `hud_message_device` |
| Inventory | → `inventory_manager` |
| Missions | → `mission_manager` |

> Aparella **BagProps[i]** amb **BagTriggers[i]**: col·loca cada prop i el seu
> trigger junts, en el mateix ordre a les dues llistes.

### `beacon_manager`  (evolució v2)
| Camp | Assignació / valor |
|------|-----------|
| CallButton | → `conditional_button_device` (o objecte-bengala) |
| BeaconAreas | → llista de ~3 `capture_area_device` |
| BeaconProps | → llista de ~3 `creative_prop` (fum/llum) |
| BroadcastHUD | → `hud_message_device` |
| BeaconDurationSeconds | 30 |
| ChannelSeconds | 8 |
| Inventory | → `inventory_manager` |
| Missions | → `mission_manager` |

### `loadout_shop`  (evolució v2)
| Camp | Assignació / valor |
|------|-----------|
| Tier1Button / Tier1Granter / Tier1Cost | → botó, → granter, 300 |
| Tier2Button / Tier2Granter / Tier2Cost | → botó, → granter, 1000 |
| Tier3Button / Tier3Granter / Tier3Cost | → botó, → granter, 3000 |
| InsureButton / InsuranceGranter / InsuranceCost | → botó, → granter, 500 |
| ShopHUD | → `hud_message_device` |
| Inventory | → `inventory_manager` |

> Configura cada `item_granter_device` amb les armes/objectes del seu nivell
> (veure `docs/economy.md`).

---

## Part 6 — Construir el món (geometria)

Segueix `docs/zones.md`. Ordre suggerit:

1. **3 anells concèntrics** de terreny: Ravals (extern) → Centre → Bòveda (nucli).
2. Envolta-ho tot de **mar** i posa-hi el `trigger_device` de `SeaZone` a sota.
3. Col·loca els **spawners de loot** per zona (més i pitjor a fora, menys i millor
   al centre).
4. Marca cada anell amb el seu `mutator_zone_device`.
5. Col·loca les **3 extraccions fixes** (2 a Ravals, 1 al Centre) i el `storm_controller`.
6. Munta el **lobby** amb els billboards del leaderboard i la botiga de loadout.
7. Reparteix el **pool de bosses** (props+triggers) i el de **balises** en zones
   amagades; els scripts els teleporten on toca.

---

## Part 7 — Mínim jugable (v0): munta això primer

Per tenir una ronda funcional com abans possible, cableja NOMÉS el nucli i deixa
l'evolució per després:

1. `game_manager` + `raid_timer` + `zone_manager` + `loot_manager` +
   `extraction_controller` + `inventory_manager` + `mission_manager`.
2. Uns quants spawners de loot i **una** extracció.
3. `run_value_hud` (valor en pantalla) i `sea_reset_manager` (no caure al buit).

Amb això ja tens el bucle **deploy → loot → extreu → estança**. Fes playtest.

Després, per capes:
4. `extraction_leaderboard` (rànquing).
5. `heat_system` (risc visible).
6. `squad_manager` (bosses de botí).
7. `beacon_manager` (balises).
8. `loadout_shop` (economia de reinversió).

---

## Part 8 — Playtest i balanç

Mètriques objectiu a `docs/economy.md` (taxa d'extracció 35–50 %, ronda 5–8 min).
Ajusta primer: durada de ronda (`raid_timer`), densitat de loot (`loot_manager`),
i llindars de Heat (`heat_system`). Publica en privat, prova amb amics, itera.

---

## Referència ràpida de la doc

- `docs/design.md` — bucle de joc i fases
- `docs/zones.md` — els 3 anells i punts d'extracció
- `docs/economy.md` — valor, loadouts, missions, mètriques
- `docs/reused-devices.md` — què ve del Naufragi (★)
- `docs/evolution.md` — la tesi de l'evolució v2 (◆)
