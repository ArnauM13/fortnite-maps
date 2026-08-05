# Sistema de checkpoints, reset i leaderboard — guia de muntatge a l'editor

Codi Verse afegit a `Content/`. Cal compilar-lo a UEFN i col·locar uns quants
devices nadius; Verse per si sol no crea geometria ni triggers físics.

## Fitxers nous

- `player_climb_stats.verse` — classe persistable (`BestHeightMeters`) + mapa compartit.
- `player_climb_manager.verse` — funcions per llegir/actualitzar el rècord de cada jugador.
- `climb_shared_state.verse` — mapa compartit (no persistent) amb l'últim checkpoint de cada jugador.
- `climb_checkpoint.verse` — device a duplicar a cada plataforma "segura".
- `fall_reset_manager.verse` — device únic que atrapa la caiguda i teleporta al checkpoint.
- `climb_leaderboard.verse` — device que actualitza billboards amb el rànquing per alçada.
- `distant_device.verse` (modificat) — l'altímetre existent ara desa el rècord i mostra "NEW BEST!".

## Passos a UEFN

1. **Compilar Verse** (Verse Explorer → Build). Hauria de compilar net; si hi ha
   algun error de sintaxi puntual, sol ser una coma/indentació — el disseny està
   calcat dels tutorials oficials d'Epic (persistència, leaderboard, trigger_device).

2. **Checkpoints** — a cada plataforma on vulguis que es pugui reaparèixer:
   - Col·loca un **Trigger Device**, pla i ample, arran de la plataforma.
   - Arrossega el device Verse **climb_checkpoint** al costat.
   - A les seves propietats, assigna el Trigger al camp `Trigger`.
   - Repeteix a totes les plataformes clau (no cal numerar-los ni ordenar-los).

3. **Reset en caiguda** — un sol cop:
   - Col·loca un **Trigger Device** gegant, pla, molt per sota de tota la
     construcció (per sota d'on cauria mai un jugador), cobrint tota l'àrea de joc en XY.
   - Arrossega el device **fall_reset_manager** i assigna aquest trigger a `FallResetZone`.

4. **Leaderboard** — opcional però recomanat:
   - Col·loca 3–5 **Billboard Devices** a prop del punt d'inici.
   - Arrossega el device **climb_leaderboard** i assigna els billboards a `Leaderboards` (índex 0 = 1r classificat).

5. **Activar persistència** — a Island Settings, activa `bUseGameDefinedPersistence`
   (o l'opció equivalent de persistència Verse) i publica com a mínim un cop en
   sessió de playtest per confirmar que `BestHeightMeters` sobreviu a sortir/entrar.

6. **Molt recomanat: desactivar col·lisió entre jugadors.** A Island Settings,
   busca l'opció de col·lisió de jugador a jugador i desactiva-la. És l'única
   manera fiable d'evitar que et facin caure des d'una plataforma estreta quan
   hi ha 16 jugadors alhora — un dels motius de frustració més citats en aquest
   gènere.

## Estat actual del mapa (verificat sobre els actors del nivell)

Al nivell hi ha **650 actors**, però de devices Verse **només hi ha col·locat
`distance_device`** (l'altímetre). Cap `climb_checkpoint`, `fall_reset_manager`
ni `climb_leaderboard` — el codi existeix, el muntatge està pendent.

També hi ha ja al nivell, i val la pena mirar si es poden reaprofitar:
- ~33 actors amb "Trigger" (potser servibles com a plaques de checkpoint)
- 16 Player Spawns · 1 Billboard · 7 Mutator Zones · 28 Volumes

## Correccions aplicades al codi (abans del primer build)

El codi original no s'havia compilat mai i tenia errors que haurien petat el
build **després** de col·locar tots els devices. Ja estan arreglats:

1. `player_climb_manager.ReportHeight` — el cos de l'arquetip barrejava un camp
   amb una crida `MakePlayerClimbStats<constructor>(...)`. `<constructor>` és un
   especificador de *declaració*, no de *crida*; això no compila. Ara construeix
   el `player_climb_stats` amb els camps directament.
2. `player_climb_manager.GetPlayerClimbStats` — codi mort, i el seu `<decides>`
   no fallava mai. Eliminat.
3. `player_climb_stats.MakePlayerClimbStats` — sense usos després d'1 i 2. Eliminat.
4. `climb_leaderboard` — interpolava un `message` dins d'un altre `message`. Ara
   el rànquing interpola l'`agent` directament, que és com Verse resol el nom.
5. `climb_checkpoint` — nou `RespawnHeightOffset` (100 per defecte). Reaparèixer
   a l'origen exacte del trigger et deixava dins la col·lisió del terra.
6. `fall_reset_manager` — conservava `rotation{}`, cosa que t'orientava al nord
   del món a cada reaparició. Ara manté cap on miraves.

## Notes
- El codi segueix els patrons oficials d'Epic (Persistent Player Statistics,
  Make Your Own In-Game Leaderboard, trigger_device API), però **encara no s'ha
  pogut compilar** aquí (no hi ha UEFN al sandbox). Compila ABANS de col·locar
  res: si queda algun detall de sintaxi, arreglar-lo amb 0 devices posats és
  molt més barat que amb 30.
- La detecció de caiguda és 100% via el `FallResetZone` (un trigger sota el
  mapa), no per velocitat/posició — més senzill i robust que vigilar cada tick.
- `LastCheckpointMap` no és persistent entre republicacions de l'illa: el
  checkpoint sobreviu a reconnectar dins la sessió, però no a un republish.
  El rècord d'alçada (`BestHeightMeters`) sí que persisteix.
