# ONLY UP: DRIVE — Plànol de Muntatge (UEFN)

> Objectiu d'aquest document: que **només hagis de col·locar peces**, no dissenyar. Aquí tens coordenades, mides, quantitats i el cablejat exacte dels dispositius. Tot en **Unreal units**. Eix **Z = amunt**.
>
> Convenció: el mapa és una torre vertical al voltant de l'eix Z. Deixa X/Y dins d'un cilindre imaginari de ~2500 de radi perquè la càmera sempre enquadri bé i el buit es vegi.

---

## 0. Marc general

| Cosa | Valor |
|------|-------|
| Origen del mapa | (0, 0, 0) — asfalt de spawn |
| Alçada total | Z = 0 → 4400 |
| Radi de treball (X/Y) | dins de ±2500 |
| Buit visible sota | Z = -800 (volum de reset a Z = -1500) |
| Dany de caiguda | DESACTIVAT (Island Settings → Fall Damage: Off) |
| Gravetat | Normal (les zones de nitro la modifiquen localment) |

**Barrera perimetral:** posa `barrier_device` invisibles formant un tub cilíndric (o 8 parets planes) al voltant de tota la torre, a radi ~2400, de Z=-200 a Z=4600. Evita cheese i que ningú caigui "fora del món".

---

## 1. Taula mestra de seccions

Cada secció ocupa una franja d'alçada. Les X/Y són orientatives (gira l'espiral com vulguis mentre respectis el radi).

| Secció | Z inici | Z final | Trigger d'entrada (Z) | Estació/replà (Z) | Checkpoint |
|--------|---------|---------|-----------------------|-------------------|------------|
| 1 Estació de Servei | 0 | 500 | 40 | — (tot terra) | — |
| 2 L'Embús | 500 | 1200 | 520 | 900 (replà) i 1180 | CP1 @ 1180 |
| 3 Els Ponts | 1200 | 2000 | 1220 | 1980 | CP2 @ 1980 |
| 4 L'Autocinema | 2000 | 2700 | 2020 | 2680 | CP3 @ 2680 |
| 5 El Túnel | 2700 | 3300 | 2720 | 3280 | CP4 @ 3280 |
| 6 El Nus | 3300 | 4000 | 3320 | 3980 | CP5 @ 3980 |
| 7 Cim del Sol | 4000 | 4400 | 4020 | 4380 (CIM) | FINAL |

> Regla d'espaiat de plataformes: separació horitzontal ≤ **220 units** i pujada vertical ≤ **180 units** per salt normal. Amb nitro pad pots arribar a 400–500. Amb moll, ~300 amunt.

---

## 2. Secció 1 — Estació de Servei (Z 0–500)

**Peces (props/geometria):**

| Peça | Quantitat | Mida aprox. | Posició (X, Y, Z) | Notes |
|------|-----------|-------------|-------------------|-------|
| Asfalt de spawn | 1 | 2000×2000 | (0,0,0) | Terra inicial, vora cian |
| Sortidor de benzina | 4 | 120×120×260 | esglaonats de (300,0,0) a (0,600,300) | Plataformes-esglaó |
| Caixes refrescs (pila) | 3 | 100×100 | (−200,400,120)… | Esglaons intermedis |
| Marquesina (teulada) | 1 | 800×600 | (0,900,380) | Mantle final de la secció |
| Nitro pad suau | 1 | — | (0,700,300) | Puja a la marquesina |

**Dispositius:**
- `player_spawner_pad_device` ×2–4 a (±100, −200, 20).
- `trigger_device` "Sec1_Enter" a (0,0,40).
- 5× moneda (veure §9) repartides pel camí.

---

## 3. Secció 2 — L'Embús (Z 500–1200)

**Peces:**

| Peça | Quantitat | Posició Z aprox. | Notes |
|------|-----------|------------------|-------|
| Cotxes apilats (plataforma) | ~14 | 520 → 1180 | Sostres/capós, alçades 100–250 entre salts |
| Camió inclinat (rampa) | 1 | 600 | Rampa natural per pujar |
| Autobús tombat | 1 | 780 | Plataforma llarga i estreta |
| Replà furgonetes (xarxa) | 1 | 900 | Vora verda tènue, atrapa caigudes |
| Tràiler pla (estació final) | 1 | 1180 | Zona de checkpoint 1 |

**Dispositius:**
- `trigger_device` "Sec2_Enter" a (X,Y,520).
- `bouncer_device` (moll) ×2 (~650 i ~1000), aura rosa.
- Zona de checkpoint 1 (veure §8) al tràiler @ 1180.
- 10× monedes.

---

## 4. Secció 3 — Els Ponts (Z 1200–2000)

Espiral ascendent: reparteix els trams girant ~90° cada volta al voltant de Z.

**Peces:**

| Peça | Quantitat | Z | Notes |
|------|-----------|---|-------|
| Tram de pont (fix) | ~8 | 1220 → 1980 | 400×250, línies grogues |
| Rampa de sortida (off-ramp) | 3 | 1400, 1650, 1850 | Inclinades, córrer+mantle |
| Cotxe mòbil (plataforma) | 3 | 1300, 1550, 1800 | Taronja, cicle 4–5s |
| Cotxe-ascensor vertical | 1 | 1500 (recorregut ±150 Z) | Puja/baixa lent |
| Tanca grind rail | 1 | 1700 (corba) | Rosa, ~800 de llarg |
| Peatge (estació final) | 1 | 1980 | Checkpoint 2 |

**Dispositius:**
- `trigger_device` "Sec3_Enter" @ 1220.
- Plataformes mòbils: usa `prop_mover` o dispositiu de moviment/patrulla (veure §6).
- `grind_rail` (o prop de rail + volum de lliscament).
- Zona de checkpoint 2 @ 1980.
- 12× monedes (algunes sobre cotxes mòbils).

---

## 5. Secció 4 — L'Autocinema (Z 2000–2700)

**Peces:**

| Peça | Quantitat | Z | Notes |
|------|-----------|---|-------|
| Tanca publicitària (vora) | ~6 | 2020 → 2680 | Plataformes primes 150 d'ample |
| Marc de pantalla gegant | 2 | 2200, 2500 | Camí per la vora superior |
| Lletres neó D-R-I-V-E | 5 | 2350 (esglaonades) | Cada lletra un esglaó |
| Gran tanca horitzontal (xarxa) | 1 | 2300 | Atrapa la meitat superior |
| Cabina projecció (estació) | 1 | 2680 | Checkpoint 3 |

**Dispositius:**
- `trigger_device` "Sec4_Enter" @ 2020.
- **Zona de nitro:** `mutator_zone_device` a ~2400 (salt/velocitat +) que cobreix el buit gran. Marca-la amb partícules cian.
- Zona de checkpoint 3 @ 2680.
- 14× monedes.

---

## 6. Secció 5 — El Túnel Vertical (Z 2700–3300)

**Peces:**

| Peça | Quantitat | Z | Notes |
|------|-----------|---|-------|
| Disc/tram rotatori | 4 | 2760, 2920, 3080, 3220 | Radi ~300, gir lent llegible |
| Anella de túnel (esglaó) | ~6 | intercalades | Vora cian |
| Parets del túnel | — | tot el tram | Formigó, llums taronja |
| Boca del túnel (estació) | 1 | 3280 | Checkpoint 4 |

**Dispositius:**
- `trigger_device` "Sec5_Enter" @ 2720.
- **Plataformes rotatòries:** dispositiu de rotació/moviment (o `prop_mover` en mode rotació). Fletxa taronja indicant sentit.
- Zona de checkpoint 4 @ 3280.
- 12× monedes (sobre discos).

---

## 7. Secció 6 — El Nus + Secció 7 — Cim (Z 3300–4400)

**Nus (3300–4000):**

| Peça | Quantitat | Z | Notes |
|------|-----------|---|-------|
| Rampes creuades (silueta) | ~6 | 3320 → 3900 | Només el camí correcte en cian |
| Pilar fi de repòs | 3 | 3500, 3700, 3850 | 150×150 |
| Nitro pad direccional | 1 | 3600 | Creua buit enorme, fletxa rosa |
| Grind rail llarg | 1 | 3750 | Sobre el buit, glow rosa |
| Rampa recta al sol (estació) | 1 | 3980 | Checkpoint 5 (car) |

**Cim (4000–4400):**

| Peça | Quantitat | Z | Notes |
|------|-----------|---|-------|
| Grind rail final | 1 | 4020 | Cap amunt sobre el sol |
| Plataformes de neó suspeses | 3 | 4120, 4220, 4300 | Timing, sense res a sota |
| Nitro pad final | 1 | 4340 | Llança al llindar |
| PLATAFORMA DEL CIM | 1 | 4380 | Gran, daurada emissiva |
| Cotxe-trofeu | 1 | 4380 | Foto final |

**Dispositius:**
- `trigger_device` "Sec6_Enter" @ 3320 i "Sec7_Enter" @ 4020.
- `trigger_device` "FINISH" sobre la plataforma del cim @ 4380.
- Zona de checkpoint 5 @ 3980.

---

## 8. Sistema de Checkpoints (opcional, comprable)

A cada estació (§1) col·loca aquest conjunt:

1. `trigger_device` **"CP{n}_Volume"** — cobreix el replà (detecta que hi ets).
2. `conditional_button_device` o `vending_machine_device` **"CP{n}_Buy"** — comprar amb 15 monedes.
3. `teleporter_device` **"CP{n}_Respawn"** — destí de respawn d'aquest checkpoint.
4. Rètol verd + `hud_message_device` d'ajuda ("Compra checkpoint · 15 🪙").

**Cablejat a `CheckpointManager.verse`:**

| `@editable` | Assigna |
|-------------|---------|
| `CheckpointVolumes[]` | els `CP{n}_Volume` en ordre 1→5 |
| `BuyButtons[]` | els `CP{n}_Buy` en ordre 1→5 |
| `RespawnTeleporters[]` | els `CP{n}_Respawn` en ordre 1→5 |
| `Coins` | el `coin_manager` (dispositiu amb `CoinManager.verse`) |
| `CheckpointCost` | 15 |
| `PurchaseFeedback` | `hud_message_device` de confirmació |

---

## 9. Monedes (col·leccionables tipades)

Hi ha 4 tipus de moneda (valor i quantitat a `economy.md`). Fes servir un color de prop per tipus:
- **Estàndard** (groc, valor 1) · **Risc** (vermell, valor 3, en llocs exposats)
- **Mòbil** (taronja, valor 2, sobre cotxes/discos) · **Secreta** (verd, valor 5, amagada)

Per cada moneda: `trigger_device` (o botó invisible) sobre el prop; en agafar-la → `CoinManager.verse`.

**Cablejat a `CoinManager.verse`:**

| `@editable` | Assigna |
|-------------|---------|
| `StandardCoins[]` | tots els triggers de moneda estàndard |
| `RiskCoins[]` | monedes de risc |
| `MovingCoins[]` | monedes sobre plataformes mòbils |
| `SecretCoins[]` | monedes secretes |
| `CoinHUD` | comptador de fitxes |
| `StreakHUD` | indicador de ratxa (x1 → x2) |

Distribució (§economy.md): 40 estàndard / 10 risc / 8 mòbils / 5 secretes = **63**.

## 9-bis. Potenciadors, KM i reptes (retenció)

**Botiga de potenciadors** (`ConsumableShop.verse`) — 4 `button_device` a les estacions:

| `@editable` | Assigna |
|-------------|---------|
| `BuyNitro` / `BuyHover` / `BuyMagnet` / `BuyRewind` | els 4 botons |
| `Coins` | el `coin_manager` |
| `Feedback` | `hud_message_device` |

L'efecte real de cada potenciador es cabla amb el dispositiu corresponent (jump pad ocult, teleporter de rebobinat, etc.).

**Meta-progressió persistent** (`MetaProgress.verse`) — càlcul de KM en acabar + botiga del hub (cosmètics). Cabla `KMHUD`. Els cosmètics (rastres, skins de cotxe, emotes) es connecten al hub d'spawn.

**Reptes diaris** (`DailyChallengeManager.verse`) — cabla `Meta`, `Coins`, `Heights`, `ChallengeHUD` i tria els 3 reptes actius (`ActiveA/B/C` + `TargetA/B/C`). La rotació diària es fa canviant aquests valors (o amb lògica de data al UEFN).

---

## 10. Reset per caiguda (buit del fons)

- `volume_device` (o `mutator_zone` gran) a Z = -1500, cobrint tot el radi.
- En entrar → `FallResetManager.verse` teletransporta al darrer checkpoint (o spawn si no en té cap).

**Cablejat a `FallResetManager.verse`:**

| `@editable` | Assigna |
|-------------|---------|
| `VoidVolume` | el `volume_device` del fons |
| `Checkpoints` | el `checkpoint_manager` |
| `SpawnTeleporter` | `teleporter_device` a l'spawn |

---

## 11. Timer, alçada i leaderboard

- `HeightTracker.verse` → un dispositiu amb els 7 triggers d'entrada de secció + HUD d'alçada.
- `TimerDisplay.verse` → `timer_device` + `hud_message_device`.
- `LeaderboardManager.verse` → 2× `leaderboard_device` (un d'alçada màxima, un de temps al cim).

**Cablejat a `HeightTracker.verse`:**

| `@editable` | Assigna |
|-------------|---------|
| `SectionTriggers[]` | "Sec1_Enter" … "Sec7_Enter" en ordre |
| `HeightHUD` | `billboard_device`/`hud_message_device` |
| `Coins` | el `coin_manager` (bonus de secció + ratxa) |
| `Daily` | el `daily_challenge_manager` (repte "arriba a secció N") |
| `SectionCoinBonus` | 3 |

**Cablejat a `GameManager.verse`:**

| `@editable` | Assigna |
|-------------|---------|
| `Heights` | el `height_tracker` |
| `Checkpoints` | el `checkpoint_manager` |
| `Coins` | el `coin_manager` |
| `FallReset` | el `fall_reset_manager` |
| `Timer` | el `timer_display` |
| `Leaderboard` | el `leaderboard_manager` |
| `Meta` | el `meta_progress` |
| `Daily` | el `daily_challenge_manager` |
| `FinishTrigger` | el trigger "FINISH" @ 4380 |
| `WelcomeHUD` | `hud_message_device` de benvinguda |
| `TotalCoinsInMap` | 63 (per a l'accolade "totes les monedes") |

---

## 14. Vehicles (capa "Street Takeover")

> Molts vehicles, però cada un amb rol clar (veure `vehicles-and-theme.md`). Objectiu: ~120–140 props de vehicle (majoria decoració apilada) + ~8 conduïbles. Nanite + LOD agressiu als llunyans.

### Conduïbles (`vehicle_spawner_device`)

| On | Z | Vehicles | Cablejat |
|----|---|----------|----------|
| Meet a spawn | 20 | esportiu + pickup + moto | `VehicleManager.SpawnVehicles[]` |
| Cim (trofeu) | 4380 | muscle car | `VehicleManager.SummitVehicle` |
| Joyride secret | ~2400 (amagat) | quad/off-road | `VehicleManager.JoyrideVehicle` + `JoyrideTrigger` |

### Vehicles-plataforma i decoració (props + `prop_mover`)

| Secció | Props vehicle aprox. | Tipus | Rol |
|--------|----------------------|-------|-----|
| 1 Estació | 8 | tuners aparcats | decoració underglow |
| 2 L'Embús | ~30 | sedans/taxis/furgonetes/bus/camió | plataformes fixes |
| 3 Els Ponts | ~15 | cotxes mòbils + tow-truck ascensor + food truck | mòbils + gimmick |
| 4 Autocinema | ~20 | cotxes "mirant pantalla" + bus-marc | decoració + plataforma |
| 5 Túnel | ~10 | formigonera girant + cotxes encaixats | rotatori + fix |
| 6 El Nus | ~12 | monster truck + cotxe-lurch + semis | gimmick + plataforma |
| 7 Cim | ~10 | police cars amb llums | decoració (celebració) |

### Cablejat a `VehicleManager.verse`

| `@editable` | Assigna |
|-------------|---------|
| `SpawnVehicles[]` | vehicle_spawner del meet de l'spawn |
| `SummitVehicle` | vehicle_spawner del muscle car del cim |
| `SummitTrigger` | el trigger "FINISH" (o un de dedicat al cim) |
| `JoyrideVehicle` + `JoyrideTrigger` | vehicle + trigger del joyride secret |

> Els vehicles-plataforma mòbils es mouen amb `prop_mover` (com els cotxes de §4/§6), NO amb aquest script.

---

## 15. Garatge i Nivell de Conductor (progressió "+1")

> La capa idle/roguelite: degoteig de recompenses + nivell per temps/fites + arbre de millores. Detall a `progression.md`. Munta-ho al **hub d'spawn** (i replica un panell al cim).

### Dispositius de lògica (afegeix-los al bloc amagat)
- `driver_level` — XP i nivells.
- `garage_upgrades` — arbre de millores + 7 `button_device` (un per node) al garatge.

### Cablejat a `driver_level`

| `@editable` | Assigna |
|-------------|---------|
| `Meta` | el `meta_progress` |
| `LevelHUD` | `hud_message` de nivell/títol |
| `XPTickSeconds` | 10 |
| `KMPerLevel` | 15 |

### Cablejat a `garage_upgrades`

| `@editable` | Assigna |
|-------------|---------|
| `Level` | el `driver_level` |
| `Buy…` (×7) | 7 botons: Motor/Nitro/Suspensió/Dipòsit/Imant/TurboCaixa/Prestigi |
| `Feedback` | `hud_message` |

### Enllaços als sistemes existents (ja previstos als scripts)
- `coin_manager` → camps `Garage`, `Level`, `UseProgression` (aplica multiplicador + XP per moneda).
- `height_tracker` → camp `Level` (XP per secció).
- `game_manager` → camp `Level` (XP al cim).
- **Imant/velocitat/descompte:** aplica els getters del garatge al dispositiu real (mutator de velocitat per jugador, radi de recollida, cost de checkpoint). Els getters ja existeixen a `garage_upgrades.verse`.

### Leaderboards nets (integritat)
- Afegeix una **Cartelera «Garatge»** (permet millores) i mantingues la de **temps/alçada** com a **Net** (ignora millores de conducció). Opció «Sortida Neta» abans de la run (veure `progression.md`).

---

## 16. El Hub d'enganxada (spawn) — leaderboards, missions i temps

Munta un **hub a l'spawn** (i replica un panell al cim) amb tot ben visible. Veure `retention.md §0`.

### Mur de leaderboards (5 carteleres una al costat de l'altra)
- 🏔️ Alçada · ⏱️ Temps · 🪙 Fitxes · 🔥 Ratxa · 😇 Purs → `leaderboard_manager` + carteleres.
- Cartelera «El teu perfil» (Nivell + títol + KM) → llegeix `driver_level` i `meta_progress`.

### Taulell de missions
- **Diàries** → `daily_challenge_manager` (ja el tens).
- **Setmanals** → un 2n `daily_challenge_manager` amb objectius més grossos i rotació 7 dies (o amplia el Verse).
- **De carrera** → panell estàtic amb les accolades (fites d'una vegada).

### Recompenses per temps
- Col·loca `session_rewards` al bloc de lògica. Cablejat:

| `@editable` | Assigna |
|-------------|---------|
| `Meta` | el `meta_progress` |
| `RewardHUD` | `hud_message` d'avís de recompensa |
| `CheckInterval` | 60 |

- **Login diari** i **ratxa de dies:** gestiona-ho amb `meta_progress` (marca la data de l'última escalada) o un dispositiu de recompensa diària.

---

## 17. Dispositius d'engagement (pantalla, like, botiga privada)

Detall i avisos a `engagement-devices.md`.

### Leaderboard en pantalla — `live_leaderboard_hud`
| `@editable` | Assigna |
|-------------|---------|
| `Heights` | el `height_tracker` |
| `Line1/2/3 + YourLine` | 4 `hud_message` ancorats a pantalla (cantonada) |
| `RefreshSeconds` | 3 |

### Recordatori de like — `like_prompt`
| `@editable` | Assigna |
|-------------|---------|
| `PromptHUD` | `hud_message` amb el text del recordatori |
| `HappyTriggers[]` | triggers de moments alts (cim, nou rècord) |
| `PeriodicSeconds` | 0 (o un valor alt si vols recordatori suau) |

> ❗ Mai donis recompensa per fer like (política d'Epic). Només recordatori.

### Botiga privada — `private_shop` (al garatge del hub)
| `@editable` | Assigna |
|-------------|---------|
| `Meta` | el `meta_progress` |
| `Buy…` | un `button_device` per article (rastre, skin, cotxe, emote) |
| `Feedback` | `hud_message` |

> Compres persistents **per jugador**; l'efecte cosmètic s'activa només per a qui compra.

---

## 18. Fletxa indicadora (guia de direcció) — `path_arrow`

Col·loca **fletxes de neó cian** als punts on el camí no és obvi (bifurcacions, salts llargs, canvis de secció). El dispositiu encén només les de la secció actual (+ la següent) per no saturar.

| `@editable` | Assigna |
|-------------|---------|
| `SectionTriggers[]` | "Sec1_Enter" … "Sec7_Enter" (en ordre) |
| `ArrowSwitches[]` | 1 `trigger_device` interruptor per secció (co-situat amb les fletxes) |
| `NextCheckpointMarker` | marcador/waypoint on-screen al proper CP (opcional) |
| `ShowNextAndCurrent` | true (encén secció actual + següent) |

> Cada "interruptor" és un `trigger_device` que fa `Enable()/Disable()` del grup de fletxes de la seva secció. Alternativa nativa: el marcador on-screen de Fortnite cap al següent objectiu.

---

## 12. Post-process i ambient (l'estètica outrun + tuner)

- `post_process_device`: bloom alt, saturació +, grain lleuger, tint magenta/taronja. **Imprescindible.**
- Skybox/skydome: gradient de posta + sol gegant amb franges + grid a l'horitzó.
- `ambient_sound_device` / `radio_device`: synthwave (puja d'intensitat amb l'alçada; muta al túnel i abans del drop final).
- Il·luminació: molt de neó emissiu (materials emissius als accents), poca llum ambiental → el neó destaca.

---

## 13. Checklist ràpid de muntatge

- [ ] Island Settings: Fall Damage OFF, temps il·limitat, 1–16 jugadors.
- [ ] Torre construïda Z 0→4400 dins radi ±2500.
- [ ] Barrera perimetral invisible.
- [ ] 7 triggers d'entrada de secció col·locats.
- [ ] 5 estacions amb kit de checkpoint.
- [ ] ~63 monedes repartides.
- [ ] Volum de reset a Z=-1500.
- [ ] Trigger FINISH al cim.
- [ ] Tots els `.verse` copiats a `Content/` i compilats a UEFN.
- [ ] Tots els `@editable` cablejats (§8–§11).
- [ ] Post-process + skybox outrun + música.
- [ ] Vores cian a totes les plataformes (codi de color).
