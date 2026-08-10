# ONLY UP: DRIVE — Vehicles i Temàtica Actual

## Capa temàtica: "STREET TAKEOVER" (tuner meet nocturn)

Sobre la base outrun/synthwave hi posem una capa **molt de tendència ara**: una **quedada de cotxes tuning il·legal** (street takeover / car meet estil Tokyo-drift, JDM, TikTok). L'autopista congelada no és buida: està **presa per una quedada fantasma de cotxes** que puja amb tu. Neó underglow per tot arreu, fum de drift, motors revolucionant, i **nitro** com a llenguatge d'impuls.

Per què és actual i encaixa:
- **Cultura tuner / car meet** (JDM, underglow, drift) és omnipresent a xarxes ara mateix → estètica reconeixible i molt clipejable.
- **Nitro / boost / drift** connecta amb les temporades de cotxes de Fortnite → el jugador ja entén el llenguatge.
- Es fon perfecte amb l'outrun (neó + posta) sense trencar el codi de color existent.

> Regla: la temàtica és **attrezzo i so**, no canvia el codi de color de joc (cian=camí, rosa=impuls...). Els cotxes decoren; el neó funcional segueix manant.

### Accents de la capa tuner (què afegeix visualment)
- **Underglow** de neó (rosa/cian) sota gairebé tots els cotxes → il·luminació ambient "gratis".
- **Fum de drift** (partícules) en punts fixos a les estacions (quedada).
- **Decals / vinils** JDM als cotxes, matrícules amb guinys, banderes de meeting.
- **Motors revolucionant** i clàxons com a so diegètic.
- **Llums de police estàtiques** (blau/vermell) parpellejant al fons (la "poli" que mai arriba) → tensió i moviment.

---

## Filosofia: molts vehicles, 5 rols

Volem **densitat de vehicles** (una torre feta de cotxes), però cada vehicle té UN rol clar perquè no confongui:

| Rol | Color de codi | Es trepitja? | Exemple |
|-----|---------------|--------------|---------|
| 🟦 Plataforma fixa | Vora **cian** | Sí | Sostre de cotxe apilat |
| 🟧 Plataforma mòbil | Glow **taronja** | Sí (amb timing) | Cotxe que llisca, bus que oscil·la |
| 🟩 Vehicle conduïble | Marc **verd** | — (t'hi puges i condueixes) | Cotxe del meet a spawn / cim |
| ⬛ Decoració (quedada) | Sense glow funcional, underglow ambient | No | Fileres de tuners mirant |
| 🟥 Gimmick / perill | Accent **vermell** | Depèn | Grua que puja un cotxe (ascensor), monster truck que bota |

---

## Catàleg de vehicles (tipus)

Usa props de vehicle de Fab/UEFN i, pels conduïbles, `vehicle_spawner_device`. Barreja marques/tipus per donar sensació de quedada real.

### Conduïbles (`vehicle_spawner_device`)
1. **Esportiu tuner** (Whiplash) — el "hero car" del meet.
2. **Muscle car** (Growler) — al cim, com a trofeu conduïble.
3. **Pickup** (Bear) — a spawn.
4. **Off-road / quad** — joyride secret (veure §gimmicks).
5. **Moto** — àgil, a spawn.

### Plataformes mòbils i fixes (props + `prop_mover`)
6. Sedan · 7. Hatchback · 8. Cupè · 9. **Taxi** (groc, fàcil de veure) · 10. **Bus urbà** (plataforma llarga) · 11. **Tràiler / semi** (plataforma XL) · 12. **Furgoneta** · 13. **Camió de mudances** (rampa) · 14. **Autobús escolar**.

### Decoració de quedada (estàtics, underglow)
15. Fileres de tuners aparcats · 16. **Cotxe de policia** (llums) · 17. **Ambulància** · 18. **Camió de bombers** · 19. **Food truck** / **camió de gelats** (detall simpàtic) · 20. Cotxes clàssics · 21. **Grua/tow truck**.

### Gimmick / perill
22. **Grua tow-truck** com a ascensor (puja un cotxe penjat).
23. **Monster truck** que bota (plataforma que puja i baixa fort).
24. **Cotxe que revoluciona i avança** (lurch) — timing perillós.
25. **Formigonera** girant (disc rotatori temàtic al túnel).

**Objectiu de densitat:** ~**120–140 props de vehicle** a tota la torre (majoria decoració apilada), + **~8 conduïbles** repartits. Això és "molts vehicles" sense matar el rendiment (usa Nanite + instancing; els decoratius llunyans amb LOD agressiu).

---

## Vehicles per secció

| Secció | Vehicles protagonistes | Rol |
|--------|------------------------|-----|
| 1 Estació de Servei | Meet a spawn: esportiu, pickup, moto (conduïbles) + 8 tuners aparcats amb underglow | Conduïble + decoració |
| 2 L'Embús | ~30 cotxes apilats (sedans, taxis, furgonetes) + autobús tombat + camió-rampa | Plataformes fixes |
| 3 Els Ponts | Cotxes mòbils (sedan, cupè), **grua tow-truck ascensor**, food truck al peatge | Mòbils + gimmick |
| 4 L'Autocinema | Cotxes "aparcats mirant la pantalla" (quedada clàssica de drive-in) + bus com a marc | Decoració + plataforma |
| 5 El Túnel | **Formigonera** girant, cotxes encaixats a les anelles | Rotatori + fix |
| 6 El Nus | **Monster truck** que bota, cotxe-lurch, semis creuats | Gimmick + plataforma |
| 7 Cim del Sol | **Muscle car trofeu conduïble** + police cars amb llums al voltant (celebració) | Conduïble + decoració |

---

## Nitro (mecànica temàtica lligada als impulsos)

Reskin dels impulsos existents amb llenguatge tuner (mateixa funció, nou vestit):
- **Nitro pad** = els "jump pad" → ara són **tubs d'escapament / bidons de nitro** amb flama rosa.
- **Zona de nitro** = mutator de velocitat/salt → **núvol de fum de drift** cian.
- **Grind rail** = tanca → **derrapada sobre la tanca** amb espurnes.
- **Boost de moll** = pneumàtic → **roda de tuning** que et catapulta.

---

## Dispositius UEFN nous que això demana

- `vehicle_spawner_device` ×~8 (conduïbles a spawn, cim i joyride).
- Props de vehicle (Fab) en gran quantitat per apilar/decorar.
- `prop_mover` extra per als vehicles-plataforma nous (tow-truck, monster truck, formigonera, semi).
- `mutator_zone_device` per si vols una zona "drift" (poca fricció) com a gag controlat.
- Partícules: fum de drift, flama de nitro, espurnes de rail.
- Àudio: motors, revs, clàxons, sirenes llunyanes.

Detall de col·locació i quantitats: `build-layout.md §14 (Vehicles)`.
