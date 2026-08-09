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

## 9. Monedes (col·leccionables)

Per cada moneda:
- `item_spawner_device` amb un prop de moneda (o `conditional_button_device` invisible amb prop groc).
- En agafar-la → event a `CoinManager.verse` (+1).

**Cablejat a `CoinManager.verse`:**

| `@editable` | Assigna |
|-------------|---------|
| `CoinTriggers[]` | tots els triggers/botons de moneda |
| `CoinHUD` | `hud_message_device` o `billboard_device` del comptador |
| `CoinsPerPickup` | 1 |

Reparteix ~63 monedes: 5/10/12/14/12/10/0 per secció (§zones.md).

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
| `SectionNames[]` | noms de secció (opcional) |

**Cablejat a `GameManager.verse`:**

| `@editable` | Assigna |
|-------------|---------|
| `Heights` | el `height_tracker` |
| `Checkpoints` | el `checkpoint_manager` |
| `Coins` | el `coin_manager` |
| `FallReset` | el `fall_reset_manager` |
| `Timer` | el `timer_display` |
| `Leaderboard` | el `leaderboard_manager` |
| `FinishTrigger` | el trigger "FINISH" @ 4380 |
| `WelcomeHUD` | `hud_message_device` de benvinguda |

---

## 12. Post-process i ambient (l'estètica outrun)

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
