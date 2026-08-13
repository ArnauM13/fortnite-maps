# La meta (finish) i el leaderboard de temps — guia de muntatge

Fins ara el mapa no tenia final: es pujava infinit i l'únic rànquing era per
**alçada** (qui arribava més amunt). Aquests fitxers afegeixen el que faltava:
una **meta al cim** que tanca la partida del jugador, li cronometra la pujada i
el posa en un **leaderboard de temps** (el més ràpid guanya).

És el mateix patró que ja tens per l'alçada (persistència + billboard +
trigger_device dels tutorials d'Epic), duplicat per al temps. Verse per si sol
no crea geometria ni triggers físics: cal compilar-lo i col·locar uns devices.

## Com es sol fer en un Only Up

En aquest gènere la partida no "acaba" per a tothom alhora com en una ronda de
Battle Royale. Cada jugador té la seva pujada; "acabar" és **individual**:

- Poses un **trigger a la plataforma del cim**. Trepitjar-lo = has acabat.
- El **cronòmetre** compta des que comences fins que el trepitges.
- El **millor temps** de cada jugador es desa (persisteix) i s'ordena de menor a
  major en un rànquing. Això és el "score" real d'un Only Up de velocitat.
- Opcionalment el guanyador es **teleporta a un pòdium** o zona d'espectador, i
  li surt un cartell **"FINISH! 1:23.45"** (i **NEW BEST!** si ha batut el seu rècord).

No cal un "End Game Device" ni acabar la ronda: seguint el patró d'alçada que
ja funciona al teu mapa, el temps es guarda per jugador i el leaderboard es va
refrescant sol.

## Fitxers nous

- `climb_run_stats.verse` — dades: classe persistable `player_run_stats`
  (`BestTimeCentis`), l'estat de sortida per jugador i el formatador `TimeString` (M:SS.CS).
- `player_run_manager.verse` — funcions per iniciar/acabar la pujada i llegir els temps.
- `climb_finish.verse` — device de la META (trigger al cim + cartell + teleport opcional).
- `climb_time_leaderboard.verse` — billboards amb el rànquing de temps (ascendent).

## Passos a UEFN

1. **Compilar Verse** (Verse Explorer → Build). Ha de compilar amb l'altre codi
   del mapa; segueix els mateixos patrons (divisió entera com a `RaidTimer`,
   `TeleportTo`/`Teleport`, persistència com `player_climb_stats`).

2. **La meta (obligatori).**
   - Col·loca un **Trigger Device** a la **plataforma del cim**, ample i pla,
     centrat, de manera que el jugador hi passi per sobre en arribar (sense
     prémer cap botó).
   - Arrossega el device Verse **climb_finish** i assigna aquest trigger a `FinishTrigger`.
   - Propietats del trigger (com els checkpoints): **activacions il·limitades**,
     **sense VFX ni so**, **activat a l'inici**, detecció per solapament.

3. **On comença el crono** — tria una opció:
   - **Senzill:** no facis res més. El crono arrenca quan entres a la partida
     (o a l'inici). Bo si cada jugador fa una sola pujada per sessió.
   - **Reintents (recomanat per speedrun):** posa un altre **Trigger Device** a
     la **plataforma de sortida** de baix i assigna'l a `StartTrigger` del
     `climb_finish`. Cada cop que el jugador el trepitja, el crono es reinicia
     des de zero — així pot fer intents repetits sense sortir del mapa.

4. **Premi del guanyador (opcional).**
   - Si vols que el finalista vagi a un pòdium o zona d'espectadors, col·loca un
     **Teleporter Device** allà i assigna'l a `WinnerTeleporter`. Si el deixes
     buit, el jugador es queda al cim.
   - `VictoryBannerSeconds` controla quants segons dura el cartell "FINISH!".

5. **Leaderboard de temps (recomanat).**
   - Col·loca 3–5 **Billboard Devices** a prop de la sortida (així es veu el
     temps a batre abans de pujar i el resultat després).
   - Arrossega el device **climb_time_leaderboard** i assigna els billboards a
     `Leaderboards` (índex 0 = el més ràpid). Només hi surten els qui han acabat.
   - Pots tenir els DOS rànquings alhora: el d'alçada (`climb_leaderboard`) i el
     de temps (`climb_time_leaderboard`), en fileres de billboards separades.

6. **Persistència** — a Island Settings, activa `bUseGameDefinedPersistence` (ja
   et cal per l'alçada). El millor temps (`BestTimeCentis`) es desa igual que
   `BestHeightMeters` i sobreviu a sortir/entrar.

## Proves abans de publicar

- [ ] Trepitjar la meta mostra "FINISH!" amb un temps coherent (mm:ss.cs).
- [ ] La primera pujada sempre marca "NEW BEST!"; una de més lenta, no; una de
      més ràpida, sí.
- [ ] El trigger de la meta no fa soroll ni VFX.
- [ ] Amb `StartTrigger` posat, tornar a la sortida i pujar de nou dona un temps
      nou comptat des de zero.
- [ ] Amb `WinnerTeleporter` posat, el finalista apareix al pòdium.
- [ ] El leaderboard de temps ordena de més ràpid a més lent i només mostra qui
      ha acabat.
- [ ] Sortir i tornar a entrar conserva el millor temps al leaderboard.
- [ ] Amb 2 jugadors, cadascú té el SEU crono (no es barregen).

## Notes de disseny

- La meta hauria d'anar **just després del tram més dur** del mapa (el cim), com
  els checkpoints van just després d'un salt difícil: arribar-hi ha de ser la recompensa.
- El temps es mesura amb `GetSimulationElapsedTime()` (marca de sortida menys la
  d'arribada), no comptant cada tick — més precís i barat.
- `BestTimeCentis` es guarda en centèsimes de segon com a `int` per persistir net
  i ordenar de forma trivial; `TimeString` el formata a M:SS.CS només per mostrar.
- L'estat de sortida (`RunStartMap`) no és persistent a propòsit: es reescriu cada
  cop que arrenca una pujada, així que reconnectar no et deixa un crono antic.
