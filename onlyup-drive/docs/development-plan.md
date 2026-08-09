# ONLY UP: DRIVE — Pla de Desenvolupament per Fases

## Visió general

| Fase | Nom | Tipus de feina | Prioritat |
|------|-----|----------------|-----------|
| 0 | Setup i documentació | Docs | ✅ Fet |
| 1 | Blockout vertical | UEFN (geometria) | 🔴 Crític |
| 2 | Sistemes core | Verse (codi) | 🔴 Crític |
| 3 | Construcció per seccions | UEFN (art) | 🔴 Crític |
| 4 | Estètica outrun (llum/post/so) | UEFN | 🔴 Crític (és el segell) |
| 5 | Game feel + moments virals | UEFN + Verse | 🟡 Important |
| 6 | Economia i checkpoints | Verse + balanceig | 🟡 Important |
| 7 | Playtesting i balanceig | Test | 🔴 Crític |
| 8 | Publicació i llançament | Fortnite | 🔴 Crític |

Temps estimat total: **5–8 setmanes** a ritme regular.

---

## FASE 0 — Setup i documentació ✅

- [x] `README.md`
- [x] `docs/design.md`
- [x] `docs/zones.md`
- [x] `docs/visual-design.md`
- [x] `docs/build-layout.md` (plànol amb coordenades)
- [x] `docs/development-plan.md`
- [x] `docs/publishing.md` (noms, tags, miniatura)
- [x] `verse/*` (esquelets: GameManager, HeightTracker, CoinManager, CheckpointManager, FallResetManager, TimerDisplay, LeaderboardManager)

---

## FASE 1 — Blockout vertical (UEFN)

### Objectiu
Torre jugable amb caixes blanques de Z=0 a Z=4400. Sense art. Validar que TOT es pot pujar i que la caiguda és justa.

### Criteris d'èxit
- [ ] Es pot completar de baix a dalt (encara que costi molts intents).
- [ ] Cap salt és impossible per a un jugador mig.
- [ ] La dificultat puja secció a secció.
- [ ] Les "xarxes" de caiguda funcionen (no sempre caus a zero fins la secció 5).

### Tasques
- [ ] Island Settings: **Fall Damage OFF**, 1–16 jugadors, temps il·limitat.
- [ ] Muntar les 7 seccions amb cubs (mides de `build-layout.md`).
- [ ] Col·locar spawn, 7 triggers d'entrada, trigger FINISH, volum de reset (Z=-1500).
- [ ] Barrera perimetral invisible (radi ~2400).
- [ ] Marcar seccions amb colors sòlids per orientar-se durant el test.

### Lliurable
Torre completable, lletja però jugable.

---

## FASE 2 — Sistemes core (Verse)

### Objectiu
Lògica 100% funcional sobre el blockout.

### Criteris d'èxit
- [ ] Caure al buit reseteja al checkpoint/spawn correcte.
- [ ] El HUD d'alçada s'actualitza en entrar a cada secció.
- [ ] El timer arrenca i s'atura al cim.
- [ ] Arribar al cim desa temps i alçada al leaderboard.

### Scripts (compilar a UEFN)
- [ ] `HeightTracker.verse` — triggers de secció + HUD d'alçada + millor alçada.
- [ ] `FallResetManager.verse` — volum de buit → respawn.
- [ ] `TimerDisplay.verse` — timer MM:SS.
- [ ] `LeaderboardManager.verse` — temps + alçada.
- [ ] `GameManager.verse` — orquestració i detecció de victòria.

### Lliurable
Partida funcional (sense monedes/checkpoints encara).

---

## FASE 3 — Construcció per seccions (UEFN)

### Objectiu
Substituir el blockout per props reals seguint `visual-design.md`. Codi de color estricte (cian=camí, asfalt=trepitges).

- [ ] Secció 1 — benzinera (sortidors, marquesina, caixes).
- [ ] Secció 2 — embús (cotxes apilats, camió rampa, autobús, molls).
- [ ] Secció 3 — ponts (trams, off-ramps, cotxes mòbils, grind rail).
- [ ] Secció 4 — autocinema (tanques, pantalles, lletres D-R-I-V-E).
- [ ] Secció 5 — túnel (discos rotatoris, anelles).
- [ ] Secció 6 — nus (rampes silueta, pilars, rail llarg).
- [ ] Secció 7 — cim (rail final, plataformes de neó, plataforma daurada, cotxe-trofeu).
- [ ] Vora de neó cian a TOTA plataforma trepitjable.

### Lliurable
Mapa amb art complet per seccions.

---

## FASE 4 — Estètica outrun (UEFN) — EL SEGELL

### Objectiu
El look synthwave que fa que el mapa es gravi sol. Sense això, és un Only Up genèric.

- [ ] Skybox: gradient de posta + sol gegant amb franges + grid a l'horitzó.
- [ ] `post_process_device`: bloom alt, saturació +, grain, tint magenta/taronja.
- [ ] Materials emissius als accents (cian/rosa/taronja/verd/groc segons codi).
- [ ] Llum baixa ambiental perquè el neó destaqui.
- [ ] Música synthwave que puja d'intensitat amb l'alçada; silenci al túnel i abans del drop final.
- [ ] SFX: clàxons, motors, brunzit de neó, swoosh de rail, ding de moneda, drop final.

### Lliurable
El mapa "es veu" abans de jugar-lo.

---

## FASE 5 — Game feel + moments virals (UEFN + Verse)

### Objectiu
Els moments que la gent clipeja.

- [ ] Feedback satisfactori: moneda, checkpoint comprat, entrada de secció.
- [ ] Moment viral per secció:
  - [ ] Z2: gos de peluche / cotxe que "cau" decoratiu.
  - [ ] Z3: cotxe mòbil que passa just quan saltes.
  - [ ] Z4: pantalla que "s'encén" amb un loop outrun quan hi arribes.
  - [ ] Z5: llums del túnel que pulsen al ritme de la música.
  - [ ] Z6: rail llarg sobre el buit amb el sol de fons.
  - [ ] Z7: bloom explosiu + drop + cotxe-trofeu per a la foto final.
- [ ] Càmera/enquadrament pensat perquè el buit sempre es vegi (vertigen).

### Lliurable
Mapa que dona ganes de gravar.

---

## FASE 6 — Economia i checkpoints (Verse + balanceig)

### Objectiu
La capa d'accessibilitat opcional.

- [ ] `CoinManager.verse` — ~63 monedes repartides (5/10/12/14/12/10/0).
- [ ] `CheckpointManager.verse` — 5 estacions comprables (cost 15).
- [ ] Botiga de checkpoint a cada estació (botó + rètol + feedback).
- [ ] Toggle "mode pur" (desactivar compra) per als hardcore.
- [ ] Balanceig: qui agafa totes les monedes pot comprar 3–4 checkpoints.

### Lliurable
Doble públic servit: casual (checkpoints) i hardcore (net).

---

## FASE 7 — Playtesting i balanceig

- [ ] Un jugador nou arriba dalt en < 45 min amb checkpoints.
- [ ] Cap salt injust; cap cheese (parets invisibles tapen dreceres).
- [ ] Les xarxes de caiguda no fan el mapa trivial.
- [ ] Seccions 5–7 són dures però justes (aquí es fan els clips de rage/clutch).
- [ ] Performance estable amb 16 jugadors.
- [ ] Testeado per ≥3 persones externes.

### Lliurable
Mapa balancejat i divertit.

---

## FASE 8 — Publicació i llançament

- [ ] Island Settings: nom, descripció, tags (veure `publishing.md`).
- [ ] Miniatura 1920×1080 (concepte a `publishing.md`).
- [ ] Publicar via UEFN → Fortnite.
- [ ] Trailer vertical 15–30s (per a Shorts/TikTok/Reels) mostrant el drop del cim.
- [ ] Compartir codi a r/FortniteCreative, TikTok, YouTube.
- [ ] Actualitzar `README.md` amb el codi oficial.

### Post-llançament
- [ ] Fix de bugs crítics 48h.
- [ ] Escoltar on cau més la gent (analytics) i ajustar.
- [ ] Actualitzacions: skins de cotxe-trofeu, rutes noves, event de rècord.

---

## Resum per tecnologia

- **UEFN (art/construcció):** Fases 1, 3, 4, 5.
- **Verse (codi):** Fase 2 (core) i Fase 6 (economia).
- **Test:** Fase 7.
- **Publicació:** Fase 8.
