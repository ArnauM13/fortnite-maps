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

## Estructura del projecte

```
extraction-rush/
├── verse/               ← Scripts Verse (lògica del joc)
│   ├── GameManager.verse           ← Orquestra estats de la ronda
│   ├── RaidTimer.verse             ← Timer de la ronda + fases
│   ├── ZoneManager.verse           ← Nivells de perill/loot per zona
│   ├── LootManager.verse           ← Spawns de loot per nivell
│   ├── ExtractionController.verse  ← Punts d'extracció rotatius
│   ├── shared_state.verse          ← Estat compartit persistent (★ del Naufragi)
│   ├── InventoryManager.verse      ← Botí de ronda + estança persistent
│   ├── MissionManager.verse        ← Missions diàries + XP de temporada
│   ├── extraction_leaderboard.verse← Rànquing de valor (★ del Naufragi)
│   ├── run_value_hud.verse         ← Valor 💠 en risc en pantalla (★ del Naufragi)
│   └── sea_reset_manager.verse     ← Reset en caure al mar (★ del Naufragi)
├── docs/                ← Documentació i disseny
│   ├── design.md
│   ├── zones.md
│   ├── economy.md
│   └── reused-devices.md ← Mapatge de què s'ha copiat del Naufragi
└── assets/
    └── references/      ← Imatges de referència visual
```

> ★ = dispositiu copiat i adaptat del mapa **OnlyUp Naufragi** (`../OnlyUp_naufrago/`),
> que ja és funcional i compilat. Detalls a [`docs/reused-devices.md`](./docs/reused-devices.md).

## Tecnologia

- **UEFN** (Unreal Editor for Fortnite)
- **Verse** — llenguatge de scripting propi d'Epic Games
- Unreal Engine 5 (Nanite, Lumen)
- **Persistable data** (`weak_map(player, ...)`) per l'inventari entre partides

## Estat

- [x] Disseny inicial
- [ ] Zona 1 — Ravals
- [ ] Zona 2 — Centre
- [ ] Zona 3 — La Bòveda
- [ ] Sistema de loot per nivells (Verse)
- [ ] Punts d'extracció rotatius
- [ ] Inventari persistent
- [ ] Missions diàries
- [ ] Leaderboard
- [ ] Testing de balanç
- [ ] Publicació
