# ONLY UP: DRIVE — Retenció i Rejugabilitat

> El mapa es completa un cop. La feina de disseny és que la gent el jugui **cinquanta**. Aquest document recull els sistemes que fan tornar el jugador, ordenats per impacte/esforç, i marcats amb la seva viabilitat a UEFN.

Llegenda viabilitat: 🟢 fàcil · 🟡 mitjà · 🔴 requereix més Verse/treball.

---

## 0. El Hub d'enganxada (què veu el jugador que l'empeny a seguir)

Perquè tots aquests sistemes funcionin, han de ser **visibles dins del mapa**, no amagats. Munta un **hub a l'spawn** (i replica'n un panell al cim) amb tres superfícies:

### A) Leaderboards mostrats (`billboard_device` / `leaderboard`)
Una paret de rècords a l'spawn amb **5 carteleres** costat a costat: 🏔️ Alçada · ⏱️ Temps · 🪙 Fitxes · 🔥 Ratxa · 😇 Purs. Veure't al rànquing (o just a sota del següent) és el millor motor de "una altra".
- Extra: una cartelera **«El teu perfil»** amb Nivell de Conductor, títol i KM (de `driver_level` / `meta_progress`).

### B) Taulell de missions (3 capes)
Un mur amb objectius vius i el seu progrés:
- **Diàries** (roten 24h) — 3 reptes ràpids (`daily_challenge_manager`).
- **Setmanals** (roten 7 dies) — 3 reptes més grossos (més KM). Ex: "arriba al cim 3 cops", "recull 200 fitxes en total", "completa 5 diàries".
- **De carrera** (permanents, una sola vegada) — la llista d'accolades/fites (primer clear, tots els secrets, sub-8…). Sempre hi ha alguna cosa pendent.

### C) Degoteig de recompenses per temps
- **Per sessió** (`session_rewards`): +KM als 5/10/15/20/30/45/60 min → "queda't una mica més".
- **Login diari:** primera escalada del dia +20 KM; **ratxa de dies** amb premi creixent (dia 7 = premi gros).
- **Nivell de Conductor:** cada nivell (temps + fites) → +1 Punt de Garatge + KM (`driver_level`).

> Aquestes tres superfícies + el degoteig "+1" (veure `progression.md`) són el que converteix "he acabat el mapa" en "què més puc treure avui".

---

## 1. Reptes diaris (🟢🟡) — el motor #1 de retorn

3 reptes que **roten cada 24 h**. Donen KM 🏁 i es poden fer en qualsevol escalada.

Exemples de pool de reptes:
- Arriba a la secció **4** en una sola escalada.
- Recull **40 fitxes** en un intent.
- Fes un clear **sense comprar cap checkpoint**.
- Mantén una **ratxa x2** durant 2 minuts.
- Troba **2 monedes secretes**.
- Clear en menys de **12 minuts**.
- No facis servir cap potenciador durant una escalada completa.

Per què funciona: dona una **raó nova cada dia** i objectius curts abastables (no cal arribar dalt per progressar).

`DailyChallengeManager.verse` en porta l'estat i valida en events (entrada de secció, monedes, cim, etc.).

---

## 2. Modificador setmanal (🟡) — varia com se sent la torre

Cada setmana s'activa **un mutator** sobre el mateix mapa. Mateixa geometria, experiència diferent → rècords i clips nous.

| Modificador | Efecte | Sensació |
|-------------|--------|----------|
| 🚦 Hora Punta | Cotxes mòbils més ràpids i freqüents | Caòtic, timing |
| 🌫️ Boira Neó | Visibilitat reduïda, neó destaca més | Tens, atmosfèric |
| 🌙 Torn de Nit | Skybox nocturn, només neó il·lumina | Estètica alternativa (clips!) |
| 🪶 Gravetat Baixa | Salts més flotants | Més fàcil, divertit, casual |
| ⏱️ Contrarellotge | Timer visible i pressió, leaderboard de temps destacat | Competitiu |

Cada modificador té el **seu leaderboard setmanal** → competició fresca cada dilluns.

---

## 3. Leaderboards múltiples (🟢) — moltes maneres de ser el millor

No un rànquing, sinó **cinc**, perquè perfils diferents competeixin:

- 🏔️ **Alçada màxima** (per als que no arriben dalt encara).
- ⏱️ **Temps al cim** (speedrunners).
- 🪙 **Fitxes en una run** (collectors).
- 🔥 **Ratxa més llarga sense caure** (jugadors nets).
- 😇 **Clears en mode pur** (hardcore).

Clau: el de **alçada màxima** dona objectiu fins i tot a qui encara no ha acabat → no expulsa els novells.

---

## 4. Meta-progressió persistent (🔴) — el "compte" que creix

KM 🏁 + cosmètics + perks (detallat a `economy.md`). El jugador veu un **perfil que avança**: rastres de neó, skins del cotxe-trofeu, emotes al cim. Coleccionar-los és una raó de tornar independent del repte del mapa.

- **Nivell de conductor:** una barra d'XP (KM acumulats de per vida) amb títols ("Aprenent", "Repartidor", "Corredor Nocturn", "Llegenda Outrun").
- Desbloqueig visible → dopamina de progrés cada partida.

---

## 5. Accolades / fites (🟢🟡) — objectius d'una sola vegada

Recompenses úniques que donen KM i un badge:
- Primer clear.
- Primer clear pur.
- Totes les monedes en una run.
- Sub-10 / Sub-8 minuts.
- Trobar totes les secretes (mapa complet).
- 7 dies seguits escalant (ratxa de login).

Les fites de **ratxa de dies** (login streak) són de les que més retenció donen.

---

## 6. Prestigi i variants desbloquejables (🟡)

Després del **primer clear**, desbloqueges:
- **Mode Pur** com a opció destacada (sense botiga de checkpoints).
- **Torn de Nit** permanent (variant estètica).
- Skin de prestigi.

Dona una "segona muntanya" al que ja ha arribat dalt: el repte no s'acaba, escala.

---

## 7. Social i multijugador (🟡🔴) — jugar amb altres multiplica hores

- 🏁 **Mode Cursa:** fins a 16 pugen alhora; qui arriba primer. Leaderboard en viu de qui va més amunt.
- 🤝 **Ajuda d'equip:** en cursa oberta, veure els altres pujar motiva ("aquell va per la 5, jo també puc").
- 🎉 **Hub del cim:** els que arriben dalt es queden en una zona social amb emotes i el cotxe-trofeu → celebració visible = més ganes d'arribar-hi.
- 👻 **Fantasma del teu millor intent** (🔴, si és viable): una silueta que repeteix el teu PB per competir contra tu mateix.

---

## 8. Esdeveniments de temporada (🟡) — FOMO sa

Cada temporada de Fortnite: un **cosmètic de neó limitat** (rastre o skin de cotxe) aconseguible completant reptes de l'event dins d'una finestra. Rota l'skybox amb un tint temàtic (Sant Valentí rosa, Halloween morat…). Raó per tornar en dates concretes.

---

## 9. Secrets i easter eggs (🟢) — per als exploradors

- **5 monedes secretes** amagades (rere una tanca, dins un cotxe, sota un pont).
- Detalls narratius (el gos de peluche de la secció 2, una matrícula amb un guiny, una ràdio que sona si t'hi acostes).
- Una **ruta alternativa secreta** en una secció (drecera d'expert que estalvia temps però és arriscada).

Els exploradors graven "he trobat TOTS els secrets de DRIVE" → contingut gratuït.

---

## 10. Onboarding i catch-up (🟢) — que ningú marxi el primer minut

- Secció 1 ensenya sense cap risc (ja dissenyat).
- HUD d'alçada sempre visible → sempre saps que progresses.
- Xarxes de caiguda a les seccions baixes → els novells no cauen a zero i es frustren.
- Checkpoints comprables com a "botó de pànic" opcional.

Retenció comença per **no perdre el jugador els primers 3 minuts**.

---

## Prioritat d'implementació (què fer primer)

| Ordre | Sistema | Impacte | Esforç |
|-------|---------|---------|--------|
| 1 | Leaderboards múltiples | Alt | 🟢 |
| 2 | Reptes diaris | Molt alt | 🟡 |
| 3 | Meta-progressió (KM + cosmètics) | Molt alt | 🔴 |
| 4 | Modificador setmanal | Alt | 🟡 |
| 5 | Accolades + login streak | Alt | 🟢 |
| 6 | Prestigi / variants | Mitjà | 🟡 |
| 7 | Secrets / easter eggs | Mitjà | 🟢 |
| 8 | Social (cursa / hub cim) | Alt | 🟡 |
| 9 | Esdeveniments de temporada | Mitjà | 🟡 |

**MVP de retenció (llançament):** 1, 3 (mínim: alçada + cosmètic bàsic), 5, 10.
**Post-llançament (updates):** 2, 4, 6, 8, 9 — així cada update dona titular i raó per tornar.
