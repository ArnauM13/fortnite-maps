# ONLY UP: DRIVE — Economia i Progressió

L'economia converteix "una escalada" en "torno cada dia". Té **dues capes**:

1. **FITXES (⚡)** — moneda **de partida** (es reinicia cada intent). Es guanya escalant i es gasta en checkpoints i potenciadors d'un sol ús. És el motor de **decisions moment a moment**.
2. **KM (🏁)** — moneda **persistent** (es queda entre partides). Es guanya en acabar segons què has fet. Es gasta en **cosmètics i perks** al hub. És el motor de **retorn a llarg termini**.

> Regla de disseny: les FITXES fan interessant CADA salt; els KM fan interessant TORNAR demà. Cap perk pot trencar la integritat Only Up (res de volar; només marges petits i cosmètics).

---

## Capa 1 — FITXES (⚡, per partida)

### Fonts de fitxes

| Font | Valor ⚡ | Quantitat aprox. | On / com |
|------|---------|------------------|----------|
| Moneda estàndard | 1 | ~45 | Repartides pel camí segur |
| Moneda de risc (vermella) | 3 | ~10 | Llocs exposats / desviació perillosa |
| Moneda mòbil (taronja) | 2 | ~8 | Sobre cotxes/discos que es mouen (timing) |
| Moneda secreta (verda) | 5 | ~5 | Amagades (easter eggs, veure §secrets) |
| **Bonus d'entrada de secció** | 3 | ×7 = 21 | Primer cop que entres a cada secció (aquesta run) |
| **Ratxa sense caure** | +2 | variable | Cada 45s sense caure a una secció inferior |

**Total possible ~130–140 ⚡** en una escalada perfecta. Un jugador mig en recull 60–90.

### Sortides de fitxes (on es gasten)

**A) Checkpoints (preu escalat per alçada):**

| Checkpoint | Secció | Cost ⚡ |
|------------|--------|--------|
| CP1 | 2 L'Embús | 10 |
| CP2 | 3 Els Ponts | 15 |
| CP3 | 4 L'Autocinema | 20 |
| CP4 | 5 El Túnel | 30 |
| CP5 | 6 El Nus | 45 |
| **TOTAL comprar-los tots** | | **120** |

Disseny: recollir-ho gairebé tot ≈ pots comprar tots els checkpoints (seguretat total del casual). Però cada ⚡ gastada en un checkpoint és una que NO gastes en potenciadors ni en el bonus de "mode pur". **Tensió constant.**

**B) Potenciadors d'un sol ús (botiga de secció, `ConsumableShop`):**

| Potenciador | Cost ⚡ | Efecte |
|-------------|--------|--------|
| ⚡ Nitro Surge | 8 | Un salt-impuls extra llarg (superar un buit puntual) |
| 🕊️ Hover Save | 12 | 0,5s de suspensió per rescatar un aterratge fallat |
| 🧲 Imant de monedes | 6 | Atreu monedes properes durant 30s |
| ⏪ Rebobinar | 15 | Torna a la teva posició de fa 3s (un cop) |

Aquests creen microdecisions: "gasto 12 en un Hover Save abans del túnel, o els guardo per al checkpoint del Nus?".

### Modificador de ratxa (combo)

Cada 45s **sense caure de secció** activa un multiplicador visible al HUD:

`x1 → x1.5 → x2 (màx)` sobre les fitxes que reculls. Caure el reinicia a x1.
→ Premia jugar net i afegeix tensió (no vols perdre la ratxa a prop d'una moneda de risc).

---

## Capa 2 — KM (🏁, persistent entre partides)

Es calculen **en acabar** cada intent (arribis al cim o caiguis i surtis). Es guarden amb Verse `persistable` per compte del jugador.

### Fonts de KM

| Font | KM 🏁 |
|------|------|
| Alçada màxima assolida | 1 per cada 100 units (cim = 44) |
| Primera vegada que arribes al cim (compte) | +100 |
| Primera escalada del dia | +20 |
| Completar un repte diari | +30 (cadascun) |
| Clear en **mode pur** (sense comprar cap checkpoint) | +75 |
| Clear recollint **totes** les monedes | +50 |
| Nou rècord personal (alçada o temps) | +25 |

### Sortides de KM (botiga del hub — cosmètic + perks lleus)

| Article | Cost 🏁 | Tipus |
|---------|--------|-------|
| Rastre de neó (color a triar) | 60 | Cosmètic (deixa estela en pujar) |
| Skin del cotxe-trofeu del cim | 120 | Cosmètic (foto final) |
| Vehicle d'entrada a l'spawn | 100 | Cosmètic |
| Emote al cim | 80 | Cosmètic |
| Perk: comença amb CP1 gratis | 200 | Perk lleu (només el primer checkpoint) |
| Perk: imant de monedes innat (radi petit) | 150 | Perk lleu |
| Skin "Prestigi" (post primer clear pur) | 300 | Cosmètic d'estatus |

> ⚠️ Balanceig: els perks de KM han de ser **marginals**. Res que salti seccions ni doni checkpoints alts gratis; això mataria el repte i el leaderboard. Si dubtes, fes-ho cosmètic.

---

## Taula de balanceig ràpid

| Perfil de jugador | Estratègia típica | Resultat |
|-------------------|-------------------|----------|
| Casual | Recull tot, compra tots els CP | Arriba dalt amb ajuda, poc KM extra |
| Optimitzador | Recull risc/secretes, compra CP alts + potenciadors | Bon KM, bones fotos |
| Hardcore / pur | No compra CP, va net per la ratxa | Màxim KM (+75 pur, +streak), rècords |
| Explorador | Busca secretes i easter eggs | KM per secretes + accolades |

Quatre maneres de jugar la mateixa torre → rejugabilitat.

---

## Col·locació de monedes (resum per a `build-layout.md`)

| Secció | Estàndard | Risc | Mòbil | Secreta | Total |
|--------|-----------|------|-------|---------|-------|
| 1 Estació | 5 | 0 | 0 | 1 | 6 |
| 2 Embús | 8 | 1 | 1 | 1 | 11 |
| 3 Ponts | 7 | 2 | 3 | 1 | 13 |
| 4 Autocinema | 9 | 2 | 2 | 1 | 14 |
| 5 Túnel | 6 | 2 | 2 | 0 | 10 |
| 6 Nus | 5 | 3 | 0 | 1 | 9 |
| 7 Cim | 0 | 0 | 0 | 0 | 0 |
| **Total** | **40** | **10** | **8** | **5** | **63** |

(Amb bonus de secció i ratxa, el sostre efectiu puja a ~130 ⚡.)

### Cablejat Verse

- `CoinManager.verse` → arrays separats per tipus (`StandardCoins`, `RiskCoins`, `MovingCoins`, `SecretCoins`) amb el seu valor + comptador de ratxa.
- `ConsumableShop.verse` → botons de compra dels 4 potenciadors + efectes.
- `MetaProgress.verse` → càlcul de KM en acabar + saldo persistent + botiga del hub.
- `DailyChallengeManager.verse` → 3 reptes rotatius (veure `retention.md`).
