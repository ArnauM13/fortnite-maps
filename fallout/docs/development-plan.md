# FALLOUT: SURFACE — Pla de Desenvolupament

Ordre recomanat per anar de zero a un mapa jugable i publicable. Prioritza
tenir el **loop jugable com abans possible** (un blockout gris de plataformes
ja és testejable) i deixa l'art per al final.

## Fase 0 — Setup (mig dia)

- [ ] Crear projecte UEFN i copiar aquesta carpeta amb `sync-to-uefn.ps1`.
- [ ] Importar els scripts de `verse/` i compilar-los (encara sense wiring).
- [ ] Col·locar un `mutator_zone_device` que cobreixi tot el mapa:
  desactivar construcció, sense doble salt, gravetat/velocitat estàndard.

## Fase 1 — Blockout jugable (el més important)

> Objectiu: poder pujar de baix a dalt amb cubs grisos. Sense art. Si això
> és divertit, el mapa funcionarà.

- [ ] Construir les 5 seccions **només amb geometria bàsica** (veure
  `climb-sections.md`), de baix a dalt.
- [ ] Cada plataforma: verificar en playtest que el salt és possible.
- [ ] Col·locar un `volume_device` gegant sota tot el mapa = **el void**.
- [ ] Col·locar un `teleporter_device` al fons de cada secció (destí del reset).
- [ ] Playtest brutal: pujar-ho tot un cop sencer. Ajustar salts injustos.

## Fase 2 — Sistemes de Verse (el que fa que sigui un "joc")

- [ ] **HeightTracker** — llegeix l'alçada del jugador, la converteix a metres,
  guarda la millor marca i actualitza el HUD. És el cor del joc.
- [ ] **VoidReset** — quan el jugador toca el void, el teletransporta al fons de
  la seva secció actual.
- [ ] **SummitTrigger** — `trigger_device` al cim → victòria.
- [ ] **LeaderboardManager** — desa l'alçada màxima al leaderboard.
- [ ] **GameManager** — connecta tot i arrenca els loops.

Assignar totes les referències `@editable` als dispositius reals a l'editor.

## Fase 3 — Feel i feedback (el que el fa satisfactori)

- [ ] HUD d'alçada polit: número gran, "MILLOR: XX m" a sota.
- [ ] So i lleuger VFX en superar la teva millor marca.
- [ ] So de "whoosh" i impacte en caure (deixa que la caiguda es *senti*).
- [ ] Senyalitzar clarament l'únic jump pad i qualsevol tram especial.

## Fase 4 — Art i ambientació (deixar per al final!)

- [ ] Substituir el blockout gris pels props temàtics de cada secció.
- [ ] Il·luminació per secció (verd Vault → taronja superfície).
- [ ] So ambient per secció (`ambient_sound_device`).
- [ ] Skybox: de fosc soterrani a cel taronja irradiat al cim.
- [ ] Fites visuals (finestres cap a la superfície llunyana).

## Fase 5 — Polish i llançament

- [ ] Playtest amb 3-4 persones alhora (detectar salts injustos i colls d'ampolla).
- [ ] Ajustar la "lleixa de rescat" de cada secció segons on la gent es frustra.
- [ ] Portada i títol cridaners (clau per al CTR a Discover).
- [ ] Publicar, mirar mètriques de retenció, iterar la corba de dificultat.

## Regla mestra

**Blockout jugable > art bonic.** Un climber gris i divertit peta; un climber
preciós i injust, no. Fes que pujar sigui satisfactori ABANS de posar cap prop.
