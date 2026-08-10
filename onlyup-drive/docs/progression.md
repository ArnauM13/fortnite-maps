# ONLY UP: DRIVE — Progressió "+1" (El Garatge)

> Objectiu: que el jugador **rebi coses contínuament** — per temps jugat, per alçada, per nivells, per diners — amb la sensació idle/roguelite de "sempre sumo alguna cosa". Ho encaixem SENSE trencar el repte Only Up ni els rècords nets.

Tres nivells de "+1", de més ràpid a més lent:

```
 SEGONS  →  El degoteig  (+1 flotant a cada moneda, tick de KM, milestones)
 MINUTS  →  Nivell de Conductor  (XP per temps + fites → nivell → punts de garatge)
 PARTIDES→  El Garatge  (gastes punts/KM en millores incrementals +1)
```

---

## Nivell 1 · El degoteig (segons) — la sensació

Recompensa micro i constant. És pura "juice", no trenca res:
- **"+1" flotant** a cada moneda recollida (i "+3", "+5" segons el tipus).
- **Tick de KM** cada 100m de nova alçada → un petit "+1 🏁" que puja pel HUD.
- **Toasts de fita:** "Secció 4!", "Ratxa x2!", "Nou rècord!".
- **Barra de XP** sempre visible omplint-se → veus que t'acostes al següent nivell.

> Regla: com més sovint el jugador veu un "+1", més es queda. Aquí no cal balanç: són números petits i feedback visual.

---

## Nivell 2 · Nivell de Conductor (minuts) — XP per temps i fites

Un **nivell persistent** que puja amb el temps jugat I amb el que assoleixes. Cada pujada de nivell dona un **Punt de Garatge** (+1) i de tant en tant **desbloqueja** una cosa nova.

### Fonts de XP

| Font | XP | Tipus |
|------|----|-------|
| Temps viu | +1 cada 10s | passiu (temps) |
| Moneda recollida | +1 per fitxa | actiu |
| Entrar a una secció nova (aquesta run) | +10 | fita |
| Nou rècord d'alçada (per 100m) | +5 | fita |
| Arribar al cim | +100 | fita |

Barreja **temps** (progressa encara que no arribis dalt) i **fites** (premia jugar bé). Ningú es queda sense progressar.

### Corba de nivells

`XP per al nivell N = 100 × N` (Lvl 1→2 = 100 XP, Lvl 2→3 = 200 XP, …). Corba suau al principi (dopamina ràpida), més lenta després.

### Recompensa per nivell

- **+1 Punt de Garatge** (sempre).
- **+15 KM** 🏁 (sempre).
- **Desbloqueig** en nivells clau (veure l'escala d'unlocks).

### Títols (identitat visible)

| Nivell | Títol |
|--------|-------|
| 1–4 | Aprenent |
| 5–9 | Repartidor |
| 10–19 | Corredor Nocturn |
| 20–34 | Llegenda Outrun |
| 35+ | Fantasma de l'Autopista |

---

## Nivell 3 · El Garatge (partides) — millores incrementals +1

Gastes **Punts de Garatge** (i/o KM) en un arbre de millores. Cada node puja **+1 per nivell**, amb **topall**. Temàtica tuner: millores el cotxe/conductor.

| Node | Efecte per nivell | Màx | Categoria |
|------|-------------------|-----|-----------|
| 🔧 **Motor** | +2% velocitat de moviment | 5 (→+10%) | ⚙️ Conducció* |
| 💨 **Nitro** | +1 càrrega de boost d'aire | 3 | ⚙️ Conducció* |
| 🪂 **Suspensió** | +0,1s de marge d'aterratge (coyote time) | 3 | ⚙️ Conducció* |
| ⛽ **Dipòsit** | −2 al cost dels checkpoints | 3 (→−6) | 💰 Economia |
| 🧲 **Imant** | +75 de radi d'imant de monedes | 4 | 💰 Economia |
| 💰 **Turbo-caixa** | +10% a totes les fitxes i KM | 5 (→+50%) | 💰 Economia |
| ✨ **Prestigi** | reinicia l'arbre → +25% global permanent | ∞ | 🔁 Idle |

\* **Conducció** = afecta la dificultat de l'escalada.

### Prestigi (el bucle idle infinit)

Quan tens l'arbre ben pujat, pots **Prestigiar**: reinicies els nodes a 0 però guanyes un **+25% global permanent** (s'acumula) i un badge d'estatus. És el "New Game+" que dona sostre infinit als hardcore i motiu per re-escalar.

---

## ⚠️ Com NO trencar el joc (la part important)

Les millores de **Conducció** (Motor/Nitro/Suspensió) canvien com se sent l'escalada. Si no ho gestionem, maten el repte i embruten els rècords. Solució en tres regles:

1. **Topalls petits.** +10% de velocitat màx no és "volar", és QoL per a veterans. Res de salts que s'estalvien seccions.
2. **Leaderboards separats.**
   - 🏆 **Board Garatge** — permet totes les millores (progressió lliure).
   - 😇 **Board Net / Pur** — ignora Motor/Nitro/Suspensió/Dipòsit. És el rècord "real".
   - Economia (Imant/Turbo-caixa) no afecta la dificultat → val a tots els boards.
3. **Toggle "Sortida Neta".** Abans d'una run pots desactivar les millores de conducció per competir net (i guanyes +KM per fer-ho, com el mode pur).

Així el casual sent progressió infinita i el hardcore té el seu rècord immaculat. Tothom content.

---

## Escala d'unlocks (què "et van donant" i quan)

El degoteig de coses noves lligat al Nivell de Conductor:

| Nivell | Desbloqueig |
|--------|-------------|
| 2 | Rastre de neó bàsic + primer node de garatge |
| 3 | 2n slot de repte diari |
| 5 | Vehicle conduïble nou al meet + node Turbo-caixa |
| 8 | Modificador "Torn de Nit" a voluntat |
| 10 | Board Garatge + skin de prestigi tier 1 |
| 15 | Node Nitro + emote al cim |
| 20 | Prestigi desbloquejat + títol "Llegenda Outrun" |
| 35 | Skin "Fantasma" + color d'underglow exclusiu |

---

## Com encaixa amb el que ja hi ha

- Usa la **moneda KM** 🏁 (`MetaProgress.verse`) que ja tens — no inventem moneda nova.
- El **Nivell de Conductor** (`DriverLevel.verse`) llegeix events que ja emeten `HeightTracker`, `CoinManager` i `GameManager`.
- El **Garatge** (`GarageUpgrades.verse`) exposa getters (`GetMoveSpeedBonus()`, `GetMagnetRadius()`, `GetEarnMultiplier()`, `GetCheckpointDiscount()`) que els altres sistemes consulten.
- Persistència: tot va al mateix `weak_map` persistent per compte de jugador.

### Fluxos de dades

```
temps + fites ──► DriverLevel ──► Punts de Garatge ──► GarageUpgrades
                      │                                      │
                      └── unlocks (cosmètics, slots) ◄───────┘
CoinManager.Collect ─► aplica GetEarnMultiplier() i GetMagnetRadius()
CheckpointManager  ─► aplica GetCheckpointDiscount()
Moviment del jugador ─► aplica GetMoveSpeedBonus()  (si NO és Sortida Neta)
```

Cablejat concret: `build-layout.md §15 (Garatge i Nivell)`.
