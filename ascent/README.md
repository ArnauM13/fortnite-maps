# ASCENT — Fortnite UEFN Parkour Map

> Una megaestructura s'enfonsa. Tu puges. L'aigua no t'espera.

## Concepte

Mapa de parkour vertical per Fortnite (UEFN) on el jugador ha de pujar 5 zones temàtiques mentre l'aigua puja des de baix. Cada caiguda al buit et fa tornar al darrer checkpoint.

## Zones

| Zona | Tema | Dificultat |
|------|------|------------|
| 1 — Soterrani | Industrial / Canonades | ⭐ Tutorial |
| 2 — Aparcament | Formigó / Cotxes | ⭐⭐ Fàcil |
| 3 — Oficines | Vidre / Caos | ⭐⭐⭐ Mitjà |
| 4 — Teulades | Exterior / Vent | ⭐⭐⭐⭐ Difícil |
| 5 — El Cim | Antena / Final | ⭐⭐⭐⭐⭐ Climax |

## Mecàniques

- Aigua que puja gradualment (mort instantània al contacte)
- Checkpoints per zona
- Timer en pantalla
- Leaderboard de millors temps

## Estructura del projecte

```
ascent-fortnite/
├── verse/               ← Scripts Verse (lògica del joc)
│   ├── GameManager.verse
│   ├── WaterController.verse
│   ├── CheckpointTracker.verse
│   ├── TimerDisplay.verse
│   └── LeaderboardManager.verse
├── docs/                ← Documentació i disseny
│   ├── design.md
│   └── zones.md
└── assets/
    └── references/      ← Imatges de referència visual
```

## Tecnologia

- **UEFN** (Unreal Editor for Fortnite)
- **Verse** — llenguatge de scripting propi d'Epic Games
- Unreal Engine 5 (Nanite, Lumen)

## Estat

- [x] Disseny inicial
- [ ] Zona 1 — Soterrani
- [ ] Zona 2 — Aparcament
- [ ] Zona 3 — Oficines
- [ ] Zona 4 — Teulades
- [ ] Zona 5 — El Cim
- [ ] Sistema d'aigua (Verse)
- [ ] Checkpoints + Timer
- [ ] Leaderboard
- [ ] Publicació
