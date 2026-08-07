# EXTRACTION RUSH — Fortnite UEFN Extraction Shooter

> Entra amb el mínim. Loot-eja el màxim. Escapa abans que la tempesta et xucli — o ho perds tot.

## Concepte

Extraction shooter per rondes curtes (5–8 min) inspirat en el gènere que més creix a Fortnite Creative (estil Tarkov / DMZ però àgil). Entres al mapa amb equipament bàsic, loot-eges armes i objectes de valor per zones cada cop més perilloses, i has d'arribar a un **punt d'extracció** abans que la tempesta et tanqui.

- **Escapes** → et quedes el botí a l'estança (persistent entre partides).
- **Mors** → ho perds tot el que portaves a sobre.

Aquesta tensió "risc-recompensa" és el motor de retenció: els jugadors tornen per no perdre el que han acumulat i per completar les missions diàries.

## Tipus

- [x] Combat (extraction / PvPvE)
- [ ] Parkour
- [ ] Deathrun
- [ ] Race
- [ ] Puzzle

## Zones

| Zona | Tema | Perill | Loot |
|------|------|--------|------|
| 1 — Ravals | Barri industrial, cobertura abundant | ⭐ Baix | 🟢 Comú |
| 2 — Centre | Edificis alts, línies de tir obertes | ⭐⭐⭐ Mitjà | 🟣 Poc comú |
| 3 — La Bòveda | Búnquer central, botí premium | ⭐⭐⭐⭐⭐ Alt | 🟡 Èpic/Daurat |

## Mecàniques

- [x] Extracció amb punts rotatius i compte enrere
- [x] Loot per nivells (verd → morat → daurat)
- [x] Inventari persistent entre partides (l'estança)
- [x] Tempesta que redueix la zona jugable (pressió temporal)
- [x] Missions diàries (XP + recompenses)
- [x] Leaderboard de valor extret
- [x] Solo / Duos / Trios

### Evolució v2 (sistemes originals)

- [x] **Heat** — el valor que portes et marca al mapa (risc visible)
- [x] **Bosses de botí** — en morir deixes el botí al terra, robable
- [x] **Abatut + reanimació** — salvament d'equip sota pressió
- [x] **Balises d'extracció** — obre una sortida al teu lloc... i avisa tothom
- [x] **Botiga de loadout + assegurança** — reinverteix l'estança a la ronda

## Estructura del projecte

```
extraction-rush/                    ← projecte UEFN
├── ExtractionRush.uefnproject      ← fitxer de projecte (plantilla)
├── ExtractionRush.uplugin          ← plugin del projecte (plantilla)
├── ExtractionRush.code-workspace   ← workspace de VS Code (plantilla)
├── .urcignore                      ← exclusions de UEFN
├── BUILD_SETUP.md                  ← ★ GUIA PER MUNTAR-HO A UEFN (cablejat)
├── Content/             ← Scripts Verse (ubicació que UEFN espera)
│   │   # --- Nucli de la ronda ---
│   ├── GameManager.verse           ← Orquestra estats de la ronda
│   ├── RaidTimer.verse             ← Timer de la ronda + fases
│   ├── ZoneManager.verse           ← Nivells de perill/loot per zona
│   ├── LootManager.verse           ← Spawns de loot per nivell
│   ├── ExtractionController.verse  ← Punts d'extracció rotatius
│   │   # --- Fonament reutilitzat del Naufragi (★) ---
│   ├── shared_state.verse          ← Estat compartit persistent
│   ├── InventoryManager.verse      ← Botí de ronda + estança persistent
│   ├── MissionManager.verse        ← Missions diàries + XP de temporada
│   ├── extraction_leaderboard.verse← Rànquing de valor
│   ├── run_value_hud.verse         ← Valor 💠 en risc en pantalla
│   ├── sea_reset_manager.verse     ← Reset en caure al mar
│   │   # --- EVOLUCIÓ v2: sistemes originals (◆) ---
│   ├── heat_system.verse           ← El valor et marca al mapa (Heat)
│   ├── squad_manager.verse         ← Morts → bosses de botí robables + reanimació
│   ├── beacon_manager.verse        ← Balises d'extracció cridables i públiques
│   └── loadout_shop.verse          ← Botiga de loadout + assegurança
├── docs/                ← Documentació i disseny
│   ├── design.md
│   ├── zones.md
│   ├── economy.md
│   ├── reused-devices.md ← Què s'ha copiat del Naufragi (★)
│   └── evolution.md      ← La tesi de l'evolució v2 (◆)
└── assets/
    └── references/      ← Imatges de referència visual
```

> ★ = fonament copiat i adaptat del mapa **OnlyUp Naufragi** (`../OnlyUp_naufrago/`).
> Detalls a [`docs/reused-devices.md`](./docs/reused-devices.md).
>
> ◆ = **evolució v2**, sistemes propis i nous (no copiats de cap mapa) que
> distingeixen Extraction Rush. Tesi de disseny a [`docs/evolution.md`](./docs/evolution.md).

## Tecnologia

- **UEFN** (Unreal Editor for Fortnite)
- **Verse** — llenguatge de scripting propi d'Epic Games
- Unreal Engine 5 (Nanite, Lumen)
- **Persistable data** (`weak_map(player, ...)`) per l'inventari entre partides

## Com muntar-ho a UEFN

👉 Segueix **[`BUILD_SETUP.md`](./BUILD_SETUP.md)**: crear el projecte, compilar el
Verse, i col·locar i **cablejar cada dispositiu** (`@editable`) pas a pas.
Comença pel "Mínim jugable (v0)" de la Part 7.

## Estat

- [x] Disseny inicial
- [x] Scripts Verse (nucli + v2)
- [x] Projecte UEFN + guia de muntatge
- [ ] Compilació del Verse a UEFN
- [ ] Zona 1 — Ravals
- [ ] Zona 2 — Centre
- [ ] Zona 3 — La Bòveda
- [ ] Cablejat de dispositius (v0 jugable)
- [ ] Capes v2 (Heat, bosses, balises, botiga)
- [ ] Testing de balanç
- [ ] Publicació
