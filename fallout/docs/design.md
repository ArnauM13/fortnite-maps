# FALLOUT: SURFACE — Game Design Document

> Un climber vertical estil **Only Up** ambientat a la wasteland de Fallout.

## Premissa

Has despertat al fons d'un Vault col·lapsat, enterrat sota dècades de runa de la
wasteland. L'única sortida és **amunt**: una columna infinita de deixalles
flotants — cotxes rovellats, bigues, portes de Vault, cartells de Nuka-Cola,
roques radioactives — apilades cap a la superfície irradiada.

Puges saltant de plataforma en plataforma. **No hi ha checkpoints. No hi ha
xarxa de seguretat.** Un sol salt fallat i caus... potser 5 metres, potser 50.
El terror de perdre el progrés és tot el joc. Arriba a la superfície.

## En què es diferencia d'ASCENT (i per què és millor per petar)

Aquest mapa **NO** és ASCENT re-tematitzat. Adopta la fórmula d'**Only Up**:

| | ASCENT | **FALLOUT: SURFACE** |
|---|---|---|
| Checkpoints | Sí (x5) | **CAP** — el cor del joc |
| Càstig de mort | Respawn al checkpoint | **Caus i perds alçada de veritat** |
| Font de tensió | Aigua que puja (rellotge) | **La por a caure** |
| Puntuació | Temps més ràpid | **Alçada màxima assolida** |
| Emoció clau | Urgència | **Frustració + "un últim intent"** |

## Per què triomfa

- **Rage-retention** — caure just abans del cim genera l'impuls irracional de
  tornar-hi. És la mecànica més enganxosa que existeix (Only Up, Getting Over It).
- **Clipeable** — caigudes èpiques i remuntades = clips de TikTok/YouTube =
  descoberta orgànica fora de Fortnite.
- **Rejugabilitat pura** — no "acabes" i marxes: competeixes per l'alçada al
  leaderboard i per superar el teu millor intent.
- **Coop tòxic-divertit** — pujar amb amics i veure'ls caure no té preu.

## Per què és fàcil de desenvolupar

- **Sense IA, sense economia, sense combat.** Només geometria + un tracker
  d'alçada + un leaderboard.
- El 90% de la feina és **col·locar plataformes** (level design), no programar.
- La lògica de Verse és mínima i tota reutilitzable (veure `verse/`).
- Un únic eix vertical → càmera i escena controlades, poc art únic.

## Bucle de joc

```
   Superfície (VICTÒRIA)  ▲
        │  ...             │  ← objectiu final
     Secció 4              │
        │                  │
     Secció 3              │   Caure't retorna a
        │                  │   la plataforma sota
     Secció 2              │   teu (o al void →
        │                  │   fons de la secció)
     Secció 1              │
        │                  │
    Fons del Vault  ───────┘  (inici)
```

El jugador puja lliurement. **No es guarda el progrés amb checkpoints**: si
caus, caus per la geometria. El HUD sempre mostra l'alçada actual i la teva
millor marca. El leaderboard rankeja per alçada màxima.

## Regles de disseny (la "sensació Only Up")

1. **Zero checkpoints reals.** L'única concessió: cada secció té un fons sòlid
   (una "lleixa") perquè una caiguda no et torni SEMPRE a l'inici absolut —
   però sí que et fa perdre tota la secció. Ajustable amb testing.
2. **Moviment pur i precís.** Es desactiva la construcció i el sprint infinit
   via `mutator_zone`. Salt estàndard, sense doble salt (excepte trams concrets
   amb jump pad, ben senyalitzats).
3. **Void reset.** Si caus fora del mapa, teletransport al fons de la secció
   actual (no game over — segueixes competint).
4. **Corba de dificultat sàdica però justa.** Cada salt ha de ser possible;
   la frustració ha de venir de l'execució, mai de salts impossibles o de bugs.
5. **Fites visuals.** Sempre veus la següent plataforma i, de tant en tant, una
   finestra cap a la superfície llunyana per recordar-te què hi ha a dalt.

## Seccions (progressió vertical)

| # | Secció | Temàtica Fallout | Dificultat |
|---|--------|------------------|------------|
| 1 | **El Vault col·lapsat** | Passadissos, portes engranatge, terminals | Tutorial |
| 2 | **La ciutat enterrada** | Cotxes apilats, semàfors, runa urbana | Fàcil-Mitjà |
| 3 | **L'autopista trencada** | Bigues, ponts penjats, cartells | Mitjà |
| 4 | **La torre de ràdio** | Antenes, escales, estructura metàl·lica prima | Difícil |
| 5 | **Ascens a la superfície** | Roques flotants, llum radioactiva, cel taronja | Brutal |

Detall plataforma a plataforma a `docs/climb-sections.md`.

## Paràmetres clau

| Paràmetre | Valor inicial | Notes |
|-----------|--------------|-------|
| Alçada total | ~6.000 u (~60 m) | A ajustar amb testing |
| Checkpoints | 0 | Innegociable — és el gènere |
| "Fons" per secció | 1 (lleixa de rescat) | Concessió mínima, ajustable |
| Jugadors | 1-8 | Cadascú puja lliure, competeixen |
| Puntuació | Alçada màxima (m) | Leaderboard descendent |
| Doble salt | Desactivat | Excepte jump pads senyalitzats |
| Construcció | Desactivada | `mutator_zone` |

## Dispositius UEFN necessaris

- `mutator_zone_device` — desactivar construcció, fixar moviment/gravetat
- `hud_message_device` — metre d'alçada (actual + millor marca)
- `leaderboard_device` — rànquing per alçada màxima
- `teleporter_device` — void reset (fons de secció) i inici
- `volume_device` / `damage_volume` — detectar el void de sota el mapa
- `trigger_device` — detectar arribada a la superfície (victòria)
- `jump_pad_device` — trams especials (ús molt limitat i senyalitzat)
- `ambient_sound_device` — vent, geiger, metall cruixint per secció
- `prop_manipulator_device` / props — plataformes temàtiques

## Idees d'expansió (post-llançament)

- **Mode "No Fall Back"** vs **"Hardcore"** (caiguda = inici absolut) com a
  variants seleccionables.
- **Fantasmes** — veure el rècord d'alçada dels amics marcat a la paret.
- **Esdeveniments** — tempesta de radiació que baixa la visibilitat uns segons.
- **Skins de dweller** desbloquejables per fites d'alçada.
- **Speedrun leaderboard** paral·lel (temps fins al cim) per als que ja dominen.
