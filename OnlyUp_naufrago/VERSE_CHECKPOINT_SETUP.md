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

2. **Checkpoints.**

   **Primer, mesura.** Puja el mapa sencer llegint l'altímetre (ja el tens al
   HUD) i apunta l'alçada de cada plataforma on t'aturaries a respirar. Aquesta
   llista és el teu pla de col·locació — no calculis res a ull.

   **Quants:** un cada 30–60 s de pujada neta. Per a la majoria de mapes Only Up
   això són **8–12 checkpoints**. Menys, i la gent abandona; més, i desapareix la
   tensió que fa funcionar el gènere. Ara mateix en tens **zero**, així que
   qualsevol xifra dins d'aquest rang ja és una millora enorme.

   **On:** SEMPRE just DESPRÉS d'un tram difícil, mai abans. Superar el salt
   dur ha de ser el que et guarda el progrés — és la recompensa. Posa'ls en
   plataformes amples on el jugador s'aturaria de manera natural.

   **Com:**
   - Un **Trigger Device** per plataforma, pla i ample, arran del terra i
     **centrat a la plataforma**. El respawn usa l'origen del trigger, o sigui
     que un trigger descentrat (o un de llarg que cobreixi dues plataformes) et
     reapareixerà al buit.
   - Arrossega el device Verse **climb_checkpoint** al costat i assigna el
     Trigger al camp `Trigger`.
   - No cal numerar-los ni ordenar-los: el darrer que trepitges guanya.

   **Comprova aquestes propietats del Trigger** (per aquí és per on peta):
   - **Nombre màxim d'activacions → il·limitat.** Si queda limitat, el
     checkpoint deixa de funcionar després de N usos. Amb 16 jugadors passant-hi
     una i altra vegada, un límit es menja de seguida.
   - **VFX i so del trigger → desactivats.** Per defecte pulsen; amb 10
     checkpoints el mapa queda ple de marcadors sorollosos.
   - **Activat a l'inici de partida → sí.**
   - Ha de detectar jugadors per solapament, sense prémer cap botó.

3. **Reset en caiguda** — un sol cop:
   - Col·loca un **Trigger Device** gegant, pla, molt per sota de tota la
     construcció (per sota d'on cauria mai un jugador), cobrint tota l'àrea de joc en XY.
   - Arrossega el device **fall_reset_manager** i assigna aquest trigger a `FallResetZone`.
   - Mateixes propietats que els altres: activacions il·limitades, sense VFX ni so.
   - **Que sobri per tots costats.** Si un jugador cau fora del volum en XY, no
     el recupera ningú i es queda caient — pitjor que abans del canvi.

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

## Proves abans de publicar

Aquest mapa ja té jugadors actius. Una regressió aquí costa jugadors reals, no
és una prova en buit. Comprova-ho tot en playtest abans de publicar:

- [ ] L'altímetre segueix funcionant i "NEW BEST!" salta en superar el rècord.
      (Els dos errors de compilació tombaven el mòdul sencer, i l'altímetre hi
      viu — és el primer que cal confirmar que no s'ha trencat.)
- [ ] Trepitjar un checkpoint no fa ni soroll ni efecte visual.
- [ ] Caure des de qualsevol punt et torna a l'últim checkpoint, dret sobre la
      plataforma i mirant cap on miraves.
- [ ] Caure ABANS del primer checkpoint et torna a l'spawn inicial.
- [ ] El mateix checkpoint funciona 10 vegades seguides (prova del límit
      d'activacions).
- [ ] Caure des de la vora exterior del mapa també et recupera — el volum de
      caiguda ha de sobrar per tots costats.
- [ ] Sortir i tornar a entrar conserva `BestHeightMeters` al leaderboard.
- [ ] Amb 2 jugadors alhora, cadascú manté el SEU checkpoint (no es trepitgen).

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
