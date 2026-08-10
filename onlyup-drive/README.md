# ONLY UP: DRIVE — Fortnite UEFN Only-Up Climb

> Una autopista congelada a mig embús puja fins al sol. Només hi ha una direcció: amunt. Cau i tornaràs a veure el trànsit passar per sota.

## Concepte

**Only Up** vertical (el gènere de "grimpar una torre de props fins al cel") fusionat amb una temàtica **automobilística / autopista** i una estètica **synthwave / outrun de posta de sol**. El jugador escala una torre surrealista feta de cotxes apilats, ponts d'autopista, tanques quilòmetriques, autocinemes flotants i senyals de neó, tot ascendint cap a un sol que no es pon mai.

El motor de retenció és el mateix que ha fet virals els Only Up: **la caiguda**. No hi ha dany de caiguda — hi ha **pèrdua de progrés**. Un error et fa lliscar torre avall i has de tornar a pujar. Això genera el bucle "una més i ho tinc" que la gent grava i comparteix.

Per no ser tan brutal com un Only Up pur (i seguir la tendència actual d'accessibilitat), s'afegeix una capa **opcional** de checkpoints que es **compren amb monedes** recollides durant l'escalada. El hardcore l'ignora i va a por el rècord net; el casual els compra i arriba dalt.

## Tipus

- [x] Parkour / Only Up (vertical climb)
- [x] Race (rècord de temps + rècord d'alçada)
- [ ] Deathrun
- [ ] Combat
- [ ] Puzzle

## Per què funcionarà (tendències actuals)

| Tendència | Com l'aprofita DRIVE |
|-----------|----------------------|
| Only Up domina Discover | És un Only Up de cap a peus (mecànica de caiguda pura) |
| Estètica synthwave/outrun molt gravada | Autopista de neó cap a posta de sol → clips fotogènics |
| Accessibilitat vs hardcore | Checkpoints opcionals comprables amb monedes |
| XP / recompensa constant | Monedes visibles per tot el recorregut |
| Clips de "rage" i de "clutch" | Caigudes llargues + salts finals sense xarxa |
| Temàtica forta i única | Ningú té un Only Up d'autopista outrun |

## Seccions (de baix a dalt)

| # | Secció | Tema | Dificultat | Alçada aprox. |
|---|--------|------|------------|---------------|
| 1 | Estació de Servei | Benzinera de neó, terra ferm | Tutorial | 0 – 500 |
| 2 | L'Embús | Cotxes apilats, primer buit | Fàcil | 500 – 1200 |
| 3 | Els Ponts | Ponts i sortides d'autopista, cotxes mòbils | Mitjà | 1200 – 2000 |
| 4 | L'Autocinema | Pantalles i tanques publicitàries flotants de neó | Mitjà-Alt | 2000 – 2700 |
| 5 | El Túnel Vertical | Trams de carretera que giren, precisió | Alt | 2700 – 3300 |
| 6 | El Nus | Nus d'autopistes (spaghetti junction), salts llargs | Molt Alt | 3300 – 4000 |
| 7 | Cim del Sol | Una recta cap al sol, seqüència final | Clímax | 4000 – 4400 |

## Mecàniques

- [x] Only Up: sense dany de caiguda, la caiguda ÉS el càstig
- [x] Reset per buit (caure al fons torna a l'últim checkpoint / spawn)
- [x] Checkpoints **opcionals** comprables amb fitxes
- [x] Economia de 2 capes: FITXES (⚡ per partida) + KM (🏁 persistents)
- [x] Monedes tipades: estàndard / risc / mòbils / secretes
- [x] Potenciadors d'un sol ús (nitro, hover, imant, rebobinar)
- [x] Ratxa "sense caure" amb multiplicador de fitxes
- [x] Reptes diaris + modificadors setmanals + meta-progressió (cosmètics)
- [x] Nitro pads (jump/boost) i molls (tires) com a impuls
- [x] Grind rails (tanques de seguretat) per velocitat
- [x] Cotxes mòbils com a plataformes amb timing
- [x] Zones de nitro (mutator: velocitat/salt augmentat)
- [x] Timer + rècord d'alçada + rècord de temps (leaderboard)
- [x] Solo (1) i cursa oberta (fins a 16)

## Estructura del projecte

```
onlyup-drive/
├── README.md                     ← aquest fitxer
├── build-playbook.html           ← ★ MANUAL INTERACTIU (obre'l al navegador; checklist amb progrés)
├── docs/
│   ├── design.md                 ← document de disseny (premissa, loop, paràmetres)
│   ├── zones.md                  ← disseny detallat de les 7 seccions
│   ├── visual-design.md          ← guia visual (colors, materials, llum)
│   ├── build-layout.md           ← ★ PLÀNOL PER MUNTAR-HO A UEFN (coords + peces + cablejat)
│   ├── development-plan.md       ← pla per fases
│   ├── economy.md                ← ★ economia de fitxes + KM (fonts, sortides, balanceig)
│   ├── retention.md              ← ★ sistemes de retenció i rejugabilitat
│   ├── publishing.md             ← noms, tipologia/tags i concepte de miniatura
│   └── thumbnail-concept.svg     ← maqueta visual de la miniatura (outrun)
└── verse/                        ← scripts Verse (esquelet, es compilen a UEFN)
    ├── GameManager.verse            ← orquestra estats de la partida
    ├── HeightTracker.verse          ← altitud, entrada de secció, bonus + ratxa
    ├── CheckpointManager.verse      ← checkpoints opcionals comprables + respawn
    ├── CoinManager.verse            ← fitxes tipades + ratxa (multiplicador)
    ├── ConsumableShop.verse         ← potenciadors d'un sol ús
    ├── MetaProgress.verse           ← KM persistents + botiga del hub
    ├── DailyChallengeManager.verse  ← reptes diaris rotatius
    ├── FallResetManager.verse       ← reset en caure al buit del fons
    ├── TimerDisplay.verse           ← timer en pantalla
    └── LeaderboardManager.verse     ← rècords (alçada / temps / fitxes...)
```

## Com muntar-ho (resum)

1. Llegeix `docs/build-layout.md` — hi ha el plànol amb **coordenades, peces i cablejat** per no haver de dissenyar res, només col·locar.
2. Crea el projecte UEFN i copia els `.verse` dins de `Content/`.
3. Compila el Verse a UEFN (**ho fas tu al UEFN**, no cal compilar aquí).
4. Col·loca els dispositius i cabla els `@editable` segons `build-layout.md`.
5. Segueix `development-plan.md` per fases (blockout → sistemes → art → test → publicar).

## Estat

- [x] Disseny inicial
- [ ] Construcció al UEFN
- [ ] Scripts Verse compilats
- [ ] Testing
- [ ] Publicació
