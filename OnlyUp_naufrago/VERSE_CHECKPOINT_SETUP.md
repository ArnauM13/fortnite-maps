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

## Notes
- El codi segueix els patrons oficials d'Epic (Persistent Player Statistics,
  Make Your Own In-Game Leaderboard, trigger_device API) però no s'ha pogut
  compilar en aquest entorn (no hi ha UEFN al sandbox). Revisa els errors del
  compilador la primera vegada — solen ser detalls menors de sintaxi.
- La detecció de caiguda és 100% via el `FallResetZone` (un trigger sota el
  mapa), no per velocitat/posició — més senzill i robust que vigilar cada tick.
