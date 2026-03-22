# ASCENT — Guia de Disseny Visual

## Principi central

> "Llegible primer, bonic després."
> El jugador mai ha de dubtar on ha d'anar ni on pot trepitjar.

---

## Sistema de color global

| Rol | Color | Ús |
|-----|-------|----|
| PERILL | Blau/cian intens | L'aigua, el buit, zones de mort |
| SEGUR | Blanc/beix clar | Totes les plataformes trepitjables |
| CAMÍ | Llum groga càlida | Direcció a seguir |
| CHECKPOINT | Verd suau | Zona segura, respira |
| DINÀMIC | Vermell suau | Plataformes que trenquen o es mouen |

Aquesta paleta es manté a totes les zones. Canvia l'estètica, no el codi de colors.

---

## Regles globals de construcció

| Regla | Motiu |
|-------|-------|
| Sempre veus la pròxima plataforma | Elimina frustració gratuïta |
| Plataformes amb contorn/bordura | Saps exactament on acaba |
| Llum sobre el camí, ombra al buit | Navegació instintiva |
| Decoració sempre als laterals | No crea confusió amb obstacles |
| Una mecànica nova per zona, no dues | El jugador aprèn d'una en una |
| Primer obstacle de cada mecànica: fàcil | Introducció sense penalització |

---

## Zona 1 · Soterrani — "Aprèn sense por"

**Paleta:** Grisos foscos + taronja industrial
**Llum:** Làmpades industrials penjades, focus sobre cada plataforma
**Mecànica nova:** Saltar, mantling bàsic

### Mides de plataformes
- Principals: 400×400 units
- Separació màxima: 200 units
- Alçada variable: 0–150 units

### Materials
- Terra: formigó rugós (textura clara = trepitjable)
- Parets: metall rovellat (decoració, no obstacle)
- Plataformes: reixa metàl·lica amb bordura taronja

### Decoració (laterals, mai al camí)
- Canonades horitzontals a les parets
- Tancs de pressió
- Làmpades industrials penjants
- Vapor en punts fixes

### Trampes: CAP — zona tutorial

---

## Zona 2 · Aparcament — "Primer timing"

**Paleta:** Formigó clar + llum fluorescent freda
**Llum:** Fluorescents al sostre, algunes parpellegen (decoratiu)
**Mecànica nova:** Plataformes mòbils (cotxes sobre rampes)

### Mides de plataformes
- Fixes: 350×350 units
- Mòbils (cotxes): 300×500 units
- Velocitat de moviment: lenta i predictible (3–4s cicle)

### Materials
- Terra: formigó clar amb marques grogues de parking
- Plataformes mòbils: sostre de cotxe (metall pintat)
- Pilars: formigó amb franges grogues

### Regla clau
Sempre veus la plataforma destí ABANS de saltar.
Els cotxes mai desapareixen del camp de visió.

### Decoració (laterals)
- Cotxes aparcats als laterals
- Senyals de parking
- Forats al sostre (llum exterior filtrant-se)

---

## Zona 3 · Oficines — "Precisió"

**Paleta:** Blanc trencat + vidre blau + caos de papers
**Llum:** Llum natural per finestres trencades (càlida, exterior)
**Mecànica nova:** Plataformes de vidre que trenquen

### Mides de plataformes
- Sòlides: 250×250 units
- Vidre: 200×200 units (trenquen als 2s)
- Separació: 150–250 units

### Sistema de vidres que trenquen
- Color normal: vidre translúcid blau clar amb contorn BLANC
- Al trepitjar: contorn canvia a VERMELL suau (1s avís)
- En trencar: efecte de so + partícules de vidre
- Mai dos vidres consecutius sense un de sòlid al mig

### Materials
- Plataformes sòlides: fusta de mobiliari d'oficina (marró clar)
- Plataformes vidre: cristall amb bordura blanca neta
- Parets: guix blanc trencat

### Decoració (laterals)
- Arxivadors tombats
- Papers flotant (partícules)
- Cadires d'oficina
- Finestres trencades amb llum entrant

---

## Zona 4 · Teulades — "Velocitat i risc"

**Paleta:** Blau nocturn + gris metàl·lic + llamps al fons
**Llum:** Nit. Llums de ciutat a baix. Rails i plataformes amb llum pròpia blanca/blava
**Mecànica nova:** Grind rails + vent lateral

### Mides de plataformes
- Teulades: 500×500 units (espai per prendre impuls)
- Separació entre teulades: 400–600 units (salts llargs)
- Rails: 600–1000 units de llarg

### Sistema de vent
- Zones de vent: marcades amb partícules visibles (línies de vent blanques)
- Efecte: empeny lateralment al jugador 200 units
- Avís visual: banderoles que es mouen en la direcció del vent

### Materials
- Teulades: metall industrial amb reixa + bordura clara
- Rails: metall brillant, emeten llum pròpia (visibles de lluny)
- Parets tècniques: antenes, dipòsits d'aigua, maquinària

### Decoració (laterals)
- Skyline de la ciutat a baix (boira blava)
- Llampecs al fons (decoratiu)
- Antenes i dipòsits
- L'AIGUA visible clarament a baix → tensió màxima

---

## Zona 5 · El Cim — "Epic final"

**Paleta:** Alba taronja/rosa + metall blanc net
**Llum:** Sol naixent, llum càlida i explosiva
**Mecànica:** Tot combinat. Sense xarxa de seguretat.

### Mides de plataformes
- Gran plataforma checkpoint: 600×600 units
- Esglaons de l'antena: 120×120 units (mínim)
- Separació: 180–220 units (precisa però assolible)

### Seqüència final
1. Gran plataforma (últim checkpoint)
2. Tres pletines horitzontals (timing)
3. Cinc esglaons de l'antena (visibles des de baix)
4. Salt final → PLATAFORMA VICTÒRIA (gran, no es pot fallar)

### Moment d'arribada
- Llum explosiva (bloom) en arribar
- Música entra a ple volum
- Confeti / partícules daurades
- Timer s'atura → apareix puntuació i leaderboard

### Materials
- Antena: metall blanc pintat, net i professional
- Plataforma final: metall daurat amb llum emissiva
- Cel: gradient alba (taronja → rosa → blau)

---

## Identitat visual per zona (resum ràpid)

| Zona | Llum dominant | Temperatura | Densitat visual |
|------|--------------|-------------|-----------------|
| 1 Soterrani | Taronja/ambre | Càlida | Baixa |
| 2 Aparcament | Blanc fred/fluorescent | Freda | Mitjana |
| 3 Oficines | Blanc natural | Neutra | Mitjana-alta |
| 4 Teulades | Blau nocturn | Molt freda | Baixa (espai obert) |
| 5 Cim | Taronja alba | Molt càlida | Mínima |
