# ONLY UP: DRIVE — Guia de Disseny Visual

## Principi central

> "Neó marca el camí. Asfalt marca on trepitges. El buit sempre es veu."
> En un Only Up el jugador no pot dubtar mai on és el següent pas — perquè fallar ja costa prou.

---

## Identitat estètica: OUTRUN / SYNTHWAVE

L'estil és el que fa que el mapa es gravi sol. No és negociable, és el segell del mapa.

- **Cel:** gradient de posta — magenta a dalt → rosa → taronja → groc a l'horitzó.
- **Sol:** gegant, baix, amb franges horitzontals negres (el sol clàssic outrun). Sempre visible al fons, cap al cim.
- **Horitzó:** graella de neó (grid retro) que s'esvaeix en la boira rosa.
- **Neó:** rosa magenta (#FF2D95) i cian (#00E5FF) com a colors d'accent per tot arreu.
- **Post-process (clau):** bloom fort, una mica de grain de pel·lícula, saturació alta, lleugera aberració cromàtica. Sense això, no és outrun.

---

## Capa temàtica: STREET TAKEOVER (tuner meet)

Sobre l'outrun s'hi suma una **quedada de cotxes tuning nocturna** (JDM, underglow, drift, nitro) — molt de tendència ara i molt clipejable. És **attrezzo i so**, no toca el codi de color de joc. Detall a `vehicles-and-theme.md`.

- **Underglow** de neó (rosa/cian) sota els cotxes → llum ambient gratis i coherent.
- **Fum de drift** (partícules) a les estacions; **flama de nitro** als pads.
- **Vinils/decals JDM**, matrícules amb guinys, banderes de meeting.
- **Llums de policia** (blau/vermell) parpellejant al fons — moviment i tensió.
- **So:** motors revolucionant, clàxons, sirenes llunyanes.

---

## Sistema de color global (codi de lectura)

Aquest codi es manté a TOTES les seccions. Canvia l'attrezzo, no el significat.

| Rol | Color | Ús |
|-----|-------|----|
| TREPITJABLE | Asfalt fosc mat / metall fosc | Tot el que aguanta el jugador |
| CAMÍ / SEGÜENT PAS | Neó **cian** (#00E5FF) | Vores, línies i fletxes cap on anar |
| IMPULS | Neó **rosa** (#FF2D95) | Nitro pads, molls, rails (elements que t'empenyen) |
| PERILL / BUIT | Res + boira rosa fosca a baix | El buit no es decora: es fa evident |
| CHECKPOINT / SEGUR | Neó **verd** (#39FF14) | Estacions, zona de compra, checkpoints |
| MONEDA | Groc / ambre brillant | Col·leccionables |
| DINÀMIC (es mou/gira) | Neó **taronja** (#FF7A00) | Cotxes mòbils, discos rotatoris |

Regla: **cian = ves-hi, rosa = t'empeny, taronja = es mou, verd = respira, groc = agafa'm.**

---

## Regles globals de construcció (Only Up)

| Regla | Motiu |
|-------|-------|
| Sempre veus la següent plataforma abans de saltar | No hi ha salts a cegues |
| Vora de neó cian a tota plataforma | Saps exactament on acaba el terra |
| El camí correcte sempre més il·luminat que la decoració | Navegació instintiva |
| Decoració (cotxes de fons, cartells) MAI trepitjable si sembla que no ho és | Res de trampes visuals |
| Una mecànica nova per secció | El jugador aprèn d'una en una |
| Primer obstacle de cada mecànica: generós | Introducció sense càstig injust |
| Trams plans (estacions) amb llum verda | El cervell entén "aquí estàs segur" |
| Parets invisibles als laterals oberts | Evitar cheese i caigudes per bug |

---

## Secció 1 · Estació de Servei — "Aprèn sense por"

**Paleta:** Asfalt negre humit + neó cian/rosa de la benzinera.
**Llum:** Fluorescents de la marquesina + rètols de neó reflectint-se a terra mullat.
**Mecànica nova:** Salt + mantle.

- **Plataformes:** sortidors i caixes, 400×400, separació ≤180, alçada 0–150.
- **Materials:** asfalt mullat (reflex), metall pintat dels sortidors, plàstic de neó.
- **Decoració (laterals):** cotxe clàssic aparcat, màquina de gel, tòtem de preus parpellejant.
- **Trampes:** CAP — tutorial.

---

## Secció 2 · L'Embús — "Confia en el salt"

**Paleta:** Carrosseries de colors apagats + primer neó rosa dels molls.
**Llum:** Fars de cotxe congelats encesos (feixos de llum estàtics), llum de posta lateral.
**Mecànica nova:** Molls (pneumàtics) + alçades variables.

- **Plataformes:** sostres/capós, 300×300 a 350×350, alçades 100–250.
- **Molls:** pneumàtics amb aura rosa; clar que et llancen amunt.
- **Materials:** metall pintat mat (sostres), goma (molls), vidre (parabrises, decoratiu).
- **Decoració:** fars encesos, maletes escampades, un gos de peluche al davant d'un cotxe (detall viral).
- **Xarxa visual:** el replà de furgonetes a ~900 té vora verda tènue.

---

## Secció 3 · Els Ponts — "Timing"

**Paleta:** Formigó de pont + línies grogues de carretera + neó taronja dels cotxes mòbils.
**Llum:** Fanals d'autopista taronja, llum de posta filtrant-se entre ponts.
**Mecànica nova:** Cotxes mòbils (taronja) + grind rail (rosa).

- **Plataformes fixes:** trams de pont, 400×250.
- **Cotxes mòbils:** taronja emissiu, cicle lent 4–5s, sempre visibles abans de saltar.
- **Grind rail:** tanca de seguretat amb glow rosa, corba, visible de lluny.
- **Materials:** formigó, asfalt amb línies grogues, metall de tanca.
- **Decoració:** fanals, senyals d'autopista ("SORTIDA ∞", "CIM 4400m"), cablejat penjant.

---

## Secció 4 · L'Autocinema — "Vertigen"

**Paleta:** Negre nocturn + explosió de neó (rètols, pantalles) + rosa/cian saturat.
**Llum:** Les pantalles i cartells EMETEN la llum principal; fons negre perquè el neó destaqui.
**Mecànica nova:** Plataformes primes penjades + zona de nitro.

- **Plataformes:** vores de tanques publicitàries, 150 d'ample; marc de pantalla, 200.
- **Zona de nitro:** volum amb partícules cian visibles + so; efecte salt/velocitat augmentat.
- **Lletres D-R-I-V-E:** neó gegant, cadascuna un esglaó.
- **Materials:** metall dels marcs, plàstic de neó, pantalla emissiva (loop de graella outrun).
- **Decoració:** cotxes de fons "aparcats" mirant una pantalla, altaveus de finestreta vintage.

---

## Secció 5 · El Túnel Vertical — "Precisió"

**Paleta:** Taronja túnel + negre + accents cian del camí correcte.
**Llum:** Llums de túnel taronja (línies laterals), ritme d'encès/apagat per marcar timing.
**Mecànica nova:** Plataformes rotatòries (taronja).

- **Plataformes rotatòries:** discos/trams de carretera, radi ~300, gir lent i llegible.
- **Anelles del túnel:** esglaons desiguals amb vora cian.
- **Materials:** formigó de túnel, ratlles reflectants, metall.
- **Regla:** el sentit i velocitat del gir sempre llegibles (fletxa taronja al disc).
- **Decoració:** llums de túnel, ventiladors gegants (decoratius, girant al fons).

---

## Secció 6 · El Nus — "Tensió"

**Paleta:** Cel de posta profund + siluetes d'autopista negres + només el camí en cian.
**Llum:** Contrallum de posta (les rampes són siluetes); el camí correcte brilla en cian.
**Mecànica nova:** Salts llargs combinats (rail + nitro direccional).

- **Plataformes:** rampes de silueta + pilars fins 150×150 de repòs.
- **Nitro pad direccional:** rosa, fletxa clara de cap a on t'llança.
- **Grind rail llarg:** sobre el buit, glow rosa intens (l'únic clar en la silueta).
- **Materials:** asfalt fosc, metall, molt contrast contra el cel.
- **Decoració:** el nus sencer com a silueta al fons; el buit rosa fosc molt avall.

---

## Secció 7 · Cim del Sol — "Clímax"

**Paleta:** El sol ho domina tot — groc/taronja/rosa saturat, bloom màxim.
**Llum:** El sol gegant al fons; les plataformes en contrallum amb vora cian.
**Mecànica:** Tot combinat, sense xarxa.

- **Plataformes finals:** rail + 3 plataformes de neó suspeses + pad final.
- **Plataforma del cim:** gran, metall daurat emissiu, dins la silueta del sol.
- **Trofeu:** un cotxe clàssic outrun aparcat al cim (foto final).
- **Arribada:** bloom explosiu, confeti de neó, drop de música, timer/leaderboard.

---

## Identitat visual per secció (resum ràpid)

| Secció | Llum dominant | Accent | Densitat visual |
|--------|--------------|--------|-----------------|
| 1 Estació | Neó fluorescent | Cian/rosa | Mitjana |
| 2 Embús | Fars + posta lateral | Rosa (molls) | Alta (caòtica) |
| 3 Ponts | Fanals taronja | Taronja (mòbils) | Mitjana |
| 4 Autocinema | Pantalles emissives | Rosa/cian (màxim) | Molt alta |
| 5 Túnel | Túnel taronja ritmat | Cian (camí) | Mitjana (tancada) |
| 6 Nus | Contrallum de posta | Cian (camí únic) | Baixa (siluetes) |
| 7 Cim | El sol (bloom) | Daurat + cian | Mínima (èpica) |

---

## Àudio (reforça l'estètica)

- **Música:** synthwave contínua que puja d'intensitat amb l'alçada (per secció).
- **Silenci tàctic:** secció 5 (túnel) i inici de la 7, perquè el drop final peti.
- **SFX diegètics:** clàxons congelats, motors, brunzit de neó, "swoosh" de rails, "ding" de moneda, drop a l'arribar al cim.
- **Feedback:** so satisfactori de checkpoint comprat i de moneda recollida.
