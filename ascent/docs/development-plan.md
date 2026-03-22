# ASCENT — Pla de Desenvolupament per Fases

## Visió general

| Fase | Nom | Tipus de feina | Prioritat |
|------|-----|----------------|-----------|
| 0 | Setup i documentació | Docs | ✅ Fet |
| 1 | Blockout | UEFN (geometria) | 🔴 Crític |
| 2 | Sistemes core | Verse (codi) | 🔴 Crític |
| 3 | Construcció per zones | UEFN (construcció) | 🔴 Crític |
| 4 | Poliment visual | UEFN (materials/llum) | 🟡 Important |
| 5 | Game feel | UEFN + Verse | 🟡 Important |
| 6 | Multijugador | Verse | 🟢 Opcional |
| 7 | Playtesting i balanceig | Test | 🔴 Crític |
| 8 | Publicació | Fortnite | 🔴 Crític |

Temps estimat total: **6–10 setmanes** treballant a ritme regular.

---

## FASE 0 — Setup i documentació ✅

### Estat: COMPLETAT

**Repositori:** `fortnite-maps/ascent/`

**Fitxers creats:**
- [x] `README.md`
- [x] `docs/design.md`
- [x] `docs/zones.md`
- [x] `docs/visual-design.md`
- [x] `verse/GameManager.verse` (esquelet)
- [x] `verse/WaterController.verse` (esquelet)
- [x] `verse/CheckpointTracker.verse` (esquelet)
- [x] `verse/TimerDisplay.verse` (esquelet)
- [x] `verse/LeaderboardManager.verse` (esquelet)

---

## FASE 1 — Blockout (UEFN)

### Objectiu
Construir la geometria bàsica del mapa amb caixes blanques (white box).
Sense materials ni decoració. Validar que el flow de joc funciona.

### Criteris d'èxit
- [ ] El mapa és completable de dalt a baix en ~15 min (primer intent)
- [ ] Cap salt és impossible o injust
- [ ] La progressió de dificultat es nota clarament
- [ ] L'aigua (placeholder) puja i amenaça el jugador

### Tasques UEFN

**Estructura vertical:**
- [ ] Crear l'illa base (plataforma de terra gran)
- [ ] Definir l'alçada total del mapa (~3000 units Unreal)
- [ ] Marcar les 5 zones amb colors sòlids diferents (vermell, verd, blau, groc, blanc)

**Zona 1 — Soterrani:**
- [ ] 6-8 plataformes blanques (400×400)
- [ ] Separació de 150-200 units
- [ ] Alçada variable: 0-150 units entre salts
- [ ] Checkpoint placeholder (cub verd)

**Zona 2 — Aparcament:**
- [ ] 4 plataformes fixes (350×350)
- [ ] 3 plataformes mòbils simples (cotxes placeholder)
- [ ] Movement device: cicle lent 3-4s
- [ ] Checkpoint placeholder

**Zona 3 — Oficines:**
- [ ] 5 plataformes sòlides (250×250)
- [ ] 4 plataformes de vidre placeholder (200×200)
- [ ] Damage volume petit per simular "trencar"
- [ ] Checkpoint placeholder

**Zona 4 — Teulades:**
- [ ] 3 teulades grans (500×500)
- [ ] 2 grind rails (600+ units)
- [ ] Zones de vent (mutator zone placeholder)
- [ ] Checkpoint placeholder

**Zona 5 — El Cim:**
- [ ] Plataforma gran (600×600) — checkpoint final
- [ ] 5 plataformes petites (120×120) en vertical
- [ ] Plataforma de victòria (trigger device)

### Lliurable
Un mapa jugable des de l'inici fins al final, sense estètica, que es pugui testejar.

---

## FASE 2 — Sistemes Core (Verse)

### Objectiu
Implementar tota la lògica de joc. Al final d'aquesta fase el joc és funcional al 100%.

### Criteris d'èxit
- [ ] L'aigua puja contínuament des de l'inici
- [ ] Tocar l'aigua mata el jugador
- [ ] Els checkpoints guarden el progrés correctament
- [ ] El timer s'inicia amb la partida i es mostra en pantalla
- [ ] Arribar al cim atura el timer i guarda la puntuació

### Script 1: `WaterController.verse`

**Funcionalitat completa:**
- [ ] Moure el `damage_volume` cap amunt cada tick
- [ ] Velocitat configurable per editor (`@editable`)
- [ ] Acceleració gradual: cada zona, +10% velocitat
- [ ] Aturar quan el jugador arriba al cim
- [ ] Funció `GetCurrentHeight()` per altres scripts

**Paràmetres editables:**
```
BaseRiseSpeed     : float = 2.0   # units/segon zona 1
AccelerationRate  : float = 0.10  # +10% cada zona
MaxHeight         : float = 2800.0
```

### Script 2: `CheckpointTracker.verse`

**Funcionalitat completa:**
- [ ] Escoltar activació dels 5 checkpoints
- [ ] Guardar zona actual per jugador
- [ ] En morir: respawn al checkpoint actiu
- [ ] Emetre event `OnZoneChanged` per altres scripts
- [ ] Mostrar missatge HUD al activar checkpoint ("Zona X — Checkpoint guardat")

### Script 3: `TimerDisplay.verse`

**Funcionalitat completa:**
- [ ] Iniciar al primer moviment del jugador
- [ ] Actualitzar HUD cada segon: `MM:SS`
- [ ] Canviar color quan l'aigua és a menys de 500 units (avís visual)
- [ ] Aturar en arribar al cim
- [ ] Retornar temps final per al leaderboard

### Script 4: `LeaderboardManager.verse`

**Funcionalitat completa:**
- [ ] Guardar puntuació en finalitzar (temps en ms)
- [ ] Mostrar leaderboard al final
- [ ] Mostrar "Millor temps personal" durant la partida (HUD petit)

### Script 5: `GameManager.verse`

**Funcionalitat completa:**
- [ ] Orquestrar tots els sistemes
- [ ] Gestionar estat: `WaitingToStart → Playing → Finished`
- [ ] Iniciar l'aigua i el timer simultàniament
- [ ] Detectar victòria i activar seqüència final
- [ ] Suport per múltiples jugadors (1-4)

### Lliurable
Partida completament funcional sobre el blockout de Fase 1.

---

## FASE 3 — Construcció per zones (UEFN)

### Objectiu
Substituir el blockout per la geometria i decoració final de cada zona.
Seguir estrictament `visual-design.md`.

### Criteri d'èxit
- [ ] Cada zona té la seva identitat visual clara
- [ ] El codi de colors (blanc=segur, cian=perill) és consistent
- [ ] El jugador sap instintivament on anar

### Zona 1 — Soterrani
- [ ] Materials: formigó rugós + reixa metàl·lica
- [ ] Làmpades industrials sobre cada plataforma
- [ ] Canonades decoratives a les parets (NO al camí)
- [ ] Color accent taronja en bordures de plataformes
- [ ] Vapor/fum en punts fixos (partícules)

### Zona 2 — Aparcament
- [ ] Materials: formigó clar + pintura de parking
- [ ] Cotxes models com a plataformes mòbils
- [ ] Fluorescents al sostre (alguns parpellegen)
- [ ] Marques grogues al terra guiant el camí
- [ ] Cotxes decoratius aparcats als laterals

### Zona 3 — Oficines
- [ ] Materials: fusta mobiliari + vidre translúcid
- [ ] Finestres trencades amb llum natural entrant
- [ ] Papers com a partícules flotant
- [ ] Vidres amb bordura blanca (normals) i vermella (trenquen)
- [ ] Cadires/arxivadors als laterals

### Zona 4 — Teulades
- [ ] Skybox: nit amb llums de ciutat a baix
- [ ] Rails metàl·lics brillants amb llum emissiva
- [ ] Banderoles indicant direcció del vent
- [ ] Antenes i dipòsits decoratius
- [ ] L'aigua visible clarament a baix

### Zona 5 — El Cim
- [ ] Skybox: alba taronja/rosa
- [ ] Antena metàl·lica blanca (estructura final)
- [ ] Plataforma victòria: metall daurat emissiu
- [ ] Partícules daurades en arribar

### Lliurable
Mapa visualment complert, amb tota la decoració i materials finals.

---

## FASE 4 — Poliment visual (UEFN)

### Objectiu
Llum, so ambient i efectes visuals que eleven el mapa a nivell professional.

### Llum
- [ ] Zona 1: Llum ambre directional + ombres llargues
- [ ] Zona 2: Llum fluorescent freda + parpelleig ocasional
- [ ] Zona 3: Llum natural càlida per finestres
- [ ] Zona 4: Llum nocturna + glow dels rails + llamps al fons
- [ ] Zona 5: Llum alba explosiva + bloom fort

### So ambient
- [ ] Zona 1: Màquines, goteres, metall (`ambient_sound_device`)
- [ ] Zona 2: Vent lleuger, ressò de cotxes, fluorescents
- [ ] Zona 3: Vent fort, vidres, papers
- [ ] Zona 4: Tempesta, trons llunyans, vent intens
- [ ] Zona 5: Silenci → música épica en arribar al cim

### Efectes visuals
- [ ] Vapor (Zona 1)
- [ ] Polsim de formigó (Zona 2, quan els cotxes es mouen)
- [ ] Papers flotant (Zona 3)
- [ ] Partícules de vent (Zona 4)
- [ ] Confeti/daurats (Zona 5, victòria)

### Lliurable
Mapa amb look final complet.

---

## FASE 5 — Game Feel (UEFN + Verse)

### Objectiu
Els moments "viral" que fan que la gent vulgui enregistrar i compartir.

### Moments espectaculars per zona
- [ ] Z1: Canonada que explota i obre el camí (trigger al arribar a cert punt)
- [ ] Z2: Cotxe que cau just quan passes per sota (timing precís)
- [ ] Z3: Planta de vidre que es trenca massivament sota els peus
- [ ] Z4: Rail llarg sobre el buit amb l'aigua visible a baix
- [ ] Z5: Salt final + llum explosiva + música

### Feedback de joc
- [ ] So de "checkpoint activat" satisfactori
- [ ] Pantalla lleugera en morir (no frustrant)
- [ ] So d'alerta quan l'aigua és a prop
- [ ] Vibració de controller quan l'aigua és molt a prop

### Lliurable
Mapa que dona ganes de repetir i enregistrar.

---

## FASE 6 — Multijugador (Verse) — Opcional

### Objectiu
Mode race per a 2-4 jugadors.

### Tasques
- [ ] Modificar `GameManager` per gestionar múltiples jugadors
- [ ] Checkpoints individuals per jugador
- [ ] Leaderboard en temps real (qui va davant)
- [ ] Missatge "X ha acabat en Y temps" per tots els jugadors
- [ ] Timer continua per als jugadors que encara estan jugant

### Lliurable
Mode race funcional per a 2-4 jugadors.

---

## FASE 7 — Playtesting i Balanceig

### Objectiu
Assegurar que el mapa és just, divertit i ben calibrat.

### Checklist de testing

**Flow de joc:**
- [ ] Un jugador nou pot completar el mapa (potser amb molts intents)
- [ ] Cap salt és impossible per a un jugador de nivell mig
- [ ] La dificultat puja de forma consistent zona a zona
- [ ] No hi ha "cheese" (camins que trenquen el disseny)

**Sistema d'aigua:**
- [ ] La velocitat és suficient per crear tensió sense ser injusta
- [ ] L'acceleració per zones es nota però no desespera
- [ ] Mai l'aigua puja tan ràpid que impossibilita completar una zona

**Checkpoints:**
- [ ] La distància entre checkpoints és correcta (no massa llarg ni massa curt)
- [ ] El respawn és instantani i no frustra

**Performance:**
- [ ] El mapa carrega en menys de 30 segons
- [ ] No hi ha drops de FPS significatius
- [ ] Funciona correctament amb 4 jugadors simultanis

### Lliurable
Mapa balancejat, testeado per almenys 3 persones externes.

---

## FASE 8 — Publicació

### Objectiu
Publicar el mapa a Fortnite Creative i preparar la llançament.

### Tasques tècniques
- [ ] Configurar `island settings` al UEFN (nom, descripció, tags)
- [ ] Afegir tags: `parkour`, `race`, `vertical`, `survival`
- [ ] Crear thumbnail del mapa (imatge 1920×1080)
- [ ] Escriure descripció del mapa per a Fortnite
- [ ] Publicar via UEFN → Fortnite Creative

### Tasques de llançament
- [ ] Gravar gameplay trailer (30-60 seg)
- [ ] Publicar a TikTok/YouTube amb el codi del mapa
- [ ] Compartir als subreddits: r/FortniteCreative, r/FortNiteBR
- [ ] Actualitzar README.md amb el codi oficial del mapa

### Post-llançament
- [ ] Recollir feedback de jugadors
- [ ] Fix de bugs crítics en les primeres 48h
- [ ] Actualitzacions periòdiques (noves zones, temps de records)

### Lliurable
Mapa publicat i accessible a tothom via codi de Fortnite.

---

## Resum de tasques per tecnologia

### UEFN (construcció al editor)
- Fase 1: Blockout (geometria bàsica)
- Fase 3: Construcció final per zones
- Fase 4: Llum, so, partícules
- Fase 5: Moments espectaculars

### Verse (codi)
- Fase 2: WaterController, CheckpointTracker, TimerDisplay, LeaderboardManager, GameManager
- Fase 5: Triggers per moments especials
- Fase 6: Multijugador (opcional)

### Testing
- Fase 7: Playtesting i balanceig

### Publicació
- Fase 8: Llançament i màrqueting
