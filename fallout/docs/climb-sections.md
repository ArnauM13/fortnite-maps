# FALLOUT: SURFACE — Disseny de Seccions

Guia de level design de baix a dalt. Regla d'or: **cada salt ha de ser
possible; la frustració ve de l'execució, mai de la injustícia.**

Alçada aproximada per secció (ajustar amb testing):

| Secció | Rang d'alçada (u) | Rang (m) |
|--------|-------------------|----------|
| 1 | 0 – 1.000 | 0 – 10 |
| 2 | 1.000 – 2.200 | 10 – 22 |
| 3 | 2.200 – 3.600 | 22 – 36 |
| 4 | 3.600 – 4.800 | 36 – 48 |
| 5 | 4.800 – 6.000 | 48 – 60 (cim) |

---

## Secció 1 — El Vault col·lapsat

**Temàtica:** Interior del Vault, portes engranatge, terminals verds, llum tènue
**Dificultat:** Tutorial — el jugador aprèn a saltar i a mesurar distàncies
**Plataformes:**
- Lleixes amples i properes (marge d'error gran)
- Portes de Vault caigudes en diagonal fan de rampes
- Terminals i taquilles com a esglaons
- Cap salt cec: sempre veus on caus

**Fons de secció (lleixa de rescat):** el terra del Vault. Caure aquí no et treu
del joc, però perds tota la secció.
**So ambient:** Zumbeig elèctric, degoteig, alarma llunyana

---

## Secció 2 — La ciutat enterrada

**Temàtica:** Cotxes rovellats apilats, semàfors torts, asfalt trencat, tuberies
**Dificultat:** Fàcil-Mitjà — primers salts amb timing i alçades variables
**Plataformes:**
- Sostres de cotxe (alçades lleugerament diferents → has de mesurar)
- Un semàfor horitzontal com a biga estreta (primer salt "de por")
- Tuberies que sobresurten de la paret
- Primer tram on veus el void a sota → introdueix la tensió de caure

**Fons de secció:** un autobús bolcat gran i pla.
**So ambient:** Vent, metall cruixint, clàxon fantasma ocasional

---

## Secció 3 — L'autopista trencada

**Temàtica:** Trams d'autopista penjats, bigues d'acer, cartells de Nuka-Cola
**Dificultat:** Mitjà — plataformes estretes, primers salts direccionals
**Plataformes:**
- Bigues d'acer primes (has d'alinear-te bé)
- Salts de cartell a cartell amb buit real a sota
- Un tram on la ruta òbvia és difícil i n'hi ha una d'alternativa amagada
- Primer i únic **jump pad** de tot el mapa, ben senyalitzat amb fletxa

**Fons de secció:** una llosa d'autopista ampla i inclinada.
**So ambient:** Vent fort d'alçada, xerric de metall sota tensió

---

## Secció 4 — La torre de ràdio

**Temàtica:** Estructura metàl·lica prima, antenes, escales de gat, llums vermells
**Dificultat:** Difícil — plataformes petites, molts salts encadenats sense marge
**Plataformes:**
- Travessers de la torre com a esglaons diminuts
- Salts en espiral al voltant del pal central (has de girar la càmera)
- Plataformes que semblen properes però estan més lluny del que sembla
- El punt on més gent caurà → la caiguda et retorna al fons de la secció 4

**Fons de secció:** la base de la torre, una plataforma d'acer.
**So ambient:** Vent xiulant, estàtica de ràdio, parpelleig elèctric

---

## Secció 5 — Ascens a la superfície

**Temàtica:** Roques flotants irradiades, llum taronja de superfície, cel obert
**Dificultat:** Brutal — l'examen final, precisió màxima
**Plataformes:**
- Roques petites i separades, algunes lleugerament inclinades
- L'últim tram: 4-5 salts perfectes seguits sense cap marge (el "clip moment")
- Al final, un trigger de victòria: surts a la superfície de la wasteland

**Victòria:** `trigger_device` al sortint final → registra alçada màxima (cim) i
mostra el leaderboard. Pantalla de cel taronja i so de vent obert.
**So ambient:** Vent net obert, comptador Geiger constant, música triomfal

---

## Checklist de level design (aplicar a cada plataforma)

- [ ] El salt és **possible** amb el moviment estàndard (provat en editor)?
- [ ] Es veu la següent plataforma **abans** de saltar (cap salt de fe cec)?
- [ ] La caiguda porta a un lloc **coherent** (lleixa de sota o fons de secció),
      no a un limbo ni fora del mapa sense void reset?
- [ ] Hi ha una **fita visual** (superfície llunyana) cada 1-2 seccions?
- [ ] La dificultat **puja de forma monòtona** (cap secció més fàcil que l'anterior)?
