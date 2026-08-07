# EXTRACTION RUSH — Disseny de Zones

El mapa és una **ciutat en 3 anells concèntrics**. Com més al centre, més perill i millor loot. La tempesta tanca de fora cap a dins, empenyent tothom cap a l'acció.

```
        ┌─────────────────────────────┐
        │        ZONA 1 — RAVALS       │   🟢 loot comú · perill baix
        │   ┌───────────────────────┐  │
        │   │    ZONA 2 — CENTRE    │  │   🟣 loot poc comú · perill mitjà
        │   │   ┌───────────────┐   │  │
        │   │   │   ZONA 3 —    │   │  │   🟡 loot èpic · perill alt
        │   │   │   LA BÒVEDA   │   │  │
        │   │   └───────────────┘   │  │
        │   └───────────────────────┘  │
        └─────────────────────────────┘
```

---

## Zona 1 — Ravals (anell exterior)

**Temàtica:** Barri industrial i portuari — magatzems, contenidors, grues, cotxes abandonats.
**Perill:** ⭐ Baix — punts de deploy, molta cobertura, PvP dispers.
**Loot:** 🟢 Comú — pistoles, escopetes bàsiques, poc valor. Ideal per no sortir amb les mans buides.
**Extracció:** 2 punts d'extracció ràpida (surts abans, però amb menys botí).
**Rol al bucle:** Onboarding de cada ronda. El jugador cautelós pot fer "smash & grab" i extreure d'hora.
**So ambient:** Grues, gavines, motors llunyans, vent portuari.

---

## Zona 2 — Centre (anell mitjà)

**Temàtica:** Nucli urbà — edificis d'oficines mitjans, places, aparcaments, metro.
**Perill:** ⭐⭐⭐ Mitjà — línies de tir obertes, verticalitat, rotacions constants.
**Loot:** 🟣 Poc comú — rifles, objectes de valor mitjà, cures i escuts.
**Extracció:** 1 punt central que s'obre a la fase de tancament.
**Rol al bucle:** El "camp de batalla" natural. Aquí es concentra el PvP quan la tempesta empeny.
**So ambient:** Trànsit fantasma, sirenes llunyanes, ressò urbà.

---

## Zona 3 — La Bòveda (nucli central)

**Temàtica:** Búnquer / cambra cuirassada sota un gratacels — passadissos estrets, portes blindades, terminals.
**Perill:** ⭐⭐⭐⭐⭐ Alt — espai tancat, poca sortida, PvE (guardians/torretes) + PvP intens.
**Loot:** 🟡 Èpic/Daurat — les millors armes, artefactes d'alt valor, la **clau daurada** (multiplicador de valor).
**Accés:** Cal una **keycard** que es troba a la Zona 2, o forçar la porta (fa soroll → atrau jugadors).
**Extracció:** NO hi ha extracció dins la Bòveda. Has d'entrar, robar i tornar a sortir cap a un punt d'extracció. Aquest "viatge de tornada" és el moment de màxima tensió.
**Rol al bucle:** L'aposta alta. Recompensa enorme, però probabilitat alta de morir carregat de botí.
**So ambient:** Zumbeig elèctric, alarmes esmorteïdes, silenci tens → alarma si forces la porta.

---

## Punts d'extracció

| Punt | Zona | S'obre a | Es tanca a | Botí requerit |
|------|------|----------|-----------|---------------|
| Moll Nord | 1 | 2:00 | 6:00 | — |
| Estació Sud | 1 | 2:00 | 6:00 | — |
| Heli-plataforma | 2 | 4:00 | 8:00 | — |

- Cada extracció requereix **8 s de canalització** dins d'una `capture_area`. Ets vulnerable mentre extreus (barra visible per a tothom → convida a emboscades).
- Els punts rotatius eviten camping predictible i forcen decisions ràpides.

## Event setmanal (retenció a llarg termini)

Un cop per setmana, La Bòveda conté un **artefacte llegendari** amb valor x5 i un cosmètic exclusiu. Genera un pic de jugadors i dona motiu per tornar cada setmana.
