# EXTRACTION RUSH — Dispositius reutilitzats del Naufragi

EXTRACTION RUSH s'aprofita del mapa **OnlyUp Naufragi** (`../OnlyUp_naufrago/`),
que ja és **funcional i compilat**. En comptes de reinventar sistemes, hem
copiat i adaptat els seus dispositius Verse provats. Això ens dona una base
robusta i ens estalvia el balanç de la infraestructura.

## Taula de correspondència

| Sistema d'Extraction Rush | Origen al Naufragi | Què s'ha canviat |
|---------------------------|--------------------|------------------|
| `shared_state.verse` | `climb_shared_state.verse` + `player_climb_stats.verse` + `player_climb_manager.verse` | Mateix patró (weak_map de mòdul + classe `persistable` + helper sense estat). Camps nous: `stash_data` (valor 💠, rondes) i `season_data` (XP, nivell) en lloc de `BestHeightMeters`. |
| `extraction_leaderboard.verse` | `climb_leaderboard.verse` | Ordena per **valor d'estança** en comptes d'alçada. Mateixos billboards i insertion sort. |
| `run_value_hud.verse` | `distant_device.verse` | Mateix widget `canvas`/`text_block` en temps real, però mostra el **valor 💠 en risc** de la ronda en lloc dels metres pujats. |
| `sea_reset_manager.verse` | `fall_reset_manager.verse` | Mateixa idea de trigger únic que atrapa la caiguda i teleporta conservant l'orientació. Retorna al **deploy anchor** (no hi ha checkpoints de progrés). Encaixa amb la temàtica naval: caure al mar. |
| Persistència d'inventari (`InventoryManager`) | Patró de `player_climb_manager` | Delega tota la lògica a `extraction_state`; s'ha eliminat el helper maldestre de mapes de la primera versió. |

## Patrons clau que hem heretat

1. **`var` de mòdul = `weak_map`, valors `persistable`.**
   Els `var` a nivell de mòdul en Verse han de ser `weak_map`, i els seus valors
   han de ser persistables (només camps plans: `int`, no `transform`). Per això
   `stash_data`/`season_data` són classes `<final><persistable>` de `int`s.
   Efecte secundari útil: l'estança i el nivell sobreviuen a reconnexions
   (encara que no a republicacions de l'illa).

2. **Helper sense estat compartit.**
   Qualsevol device crea el seu propi `extraction_state{}` i tots operen sobre
   les mateixes taules de mòdul — exactament com el Naufragi usa
   `player_climb_manager{}` des de diversos devices.

3. **Teleport conservant l'orientació.**
   `FortCharacter.TeleportTo[Position, ExistingRotation]` en lloc de `rotation{}`,
   per no desorientar el jugador en cada reset.

## Del Naufragi que NO hem copiat (però podríem)

- **`climb_checkpoint.verse`** — checkpoints per trigger. No calen a l'extraction
  shooter (no és de progressió vertical), però el mateix mecanisme serviria per a
  **punts de captura d'extracció** si volguéssim reforçar l'`ExtractionController`
  amb la lògica de trigger ja provada.
- Geometria/materials (`rosa`, `taronja`, `verd`... a `Content/`) — assets visuals
  que es poden reaprofitar per prototipar ràpidament les zones.

## Com integrar-ho a UEFN

Veure `../OnlyUp_naufrago/VERSE_CHECKPOINT_SETUP.md` per als passos de compilació
i col·locació de devices natius — el flux és idèntic (Verse Explorer → Build,
després assignar triggers/billboards/HUD a l'editor).
