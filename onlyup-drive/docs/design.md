# ONLY UP: DRIVE — Game Design Document

## Premissa

El trànsit s'ha aturat per sempre. Una autopista impossible ha quedat congelada a mig embús i s'enfila recta cap a un sol de posta que no baixa mai. El jugador comença a l'asfalt, a peu, i ha de **grimpar** per sobre de cotxes apilats, ponts trencats, tanques publicitàries i nusos d'autopista fins arribar al cim, on la carretera desapareix dins del sol.

No hi ha enemics. No hi ha dany de caiguda. L'únic enemic és **la gravetat i el teu propi pols**: un salt fallat i llisques metres i metres avall, tornant a veure passar tot el que ja havies superat.

## Gènere i referents

- **Gènere base:** *Only Up* (vertical climb de props apilats). És el format que més s'escala a Fortnite Discover: fàcil d'entendre, difícil de dominar, altíssima rejugabilitat i molt clipejable.
- **Twist temàtic:** autopista / món del motor ("Drive").
- **Estètica:** *synthwave / outrun* — neó rosa i cian, sol gegant amb franges, cel gradient magenta→taronja, graella retro a l'horitzó. Molt fotogènica → clips que es comparteixen sols.

## Bucle de joc (Game Loop)

```
Spawn (asfalt) → grimpa secció 1 → secció 2 → ... → secció 7 → CIM
        ▲                                   │
        │              (caure = llisques avall fins on t'aguantis)
        │                                   ▼
   (caure al buit del fons = reset a l'últim checkpoint o spawn)
```

### El bucle emocional (per què enganxa)

1. **Progrés visible** — sempre veus quant has pujat (HUD d'alçada + el terra que s'allunya).
2. **Tensió constant** — cada salt pot costar-te minuts de progrés.
3. **Alleujament** — arribar a una zona plana on respirar (i potser comprar checkpoint).
4. **"Una més"** — caure a prop del cim és el moment que fa tornar a jugar.

## Filosofia Only Up (regles del gènere)

| Regla | Decisió a DRIVE |
|-------|-----------------|
| Res de dany de caiguda | ✅ Mai. La caiguda és pèrdua de temps/alçada, no mort. |
| La caiguda ha de doler (però ser justa) | ✅ Hi ha "xarxes" naturals (trams plans) cada cert tram, no caus sempre a zero. |
| Checkpoints? | ⚠️ Opcionals i **comprables** amb monedes. El pur no els fa servir. |
| Moviment satisfactori | ✅ Mantle generós, pads de nitro, molls, rails. |
| Sempre saps on és el següent pas | ✅ Codi de color: asfalt fosc = trepitjable, neó = camí. |

## Paràmetres clau

| Paràmetre | Valor inicial | Notes |
|-----------|--------------|-------|
| Alçada total | ~4400 units | Unreal units (7 seccions) |
| Temps objectiu (primer clear) | 20–40 min | Only Up: llarg a propòsit |
| Temps objectiu (speedrun) | ~6–9 min | Per al leaderboard de temps |
| Jugadors simultanis | 1–16 | Cursa oberta; cadascú al seu ritme |
| Dany de caiguda | 0 | Sempre desactivat |
| Cost checkpoint | 15 monedes | Ajustable; es compren en trams plans |
| Monedes al recorregut | ~60–80 | Suficients per 3–4 checkpoints si les agafes totes |

## Sensació que volem transmetre

- **Vertigen** — sempre hi ha buit sota teu i el veus.
- **Nostàlgia outrun** — neó, sol de posta, música synthwave.
- **Domini** — quan clavas una secció que abans et costava, se sent.
- **Rècord** — el HUD d'alçada i el leaderboard conviden a superar-se.

## Modes

- **Escalada (principal):** de baix a dalt, al teu ritme. Rècord d'alçada personal.
- **Contrarellotge:** timer des del primer moviment fins al cim. Leaderboard de temps.
- **Pur (toggle):** desactiva la compra de checkpoints per als hardcore.

## Dispositius UEFN necessaris (resum)

> El detall exacte (quantitats, on va cada cosa i com es cabla) és a `build-layout.md`.

- `player_spawner_pad_device` — spawn a l'asfalt
- `trigger_device` — entrada de cada secció (x7), cim (x1), volums de checkpoint
- `capture_area_device` / `mutator_zone_device` — zones de nitro (velocitat/salt)
- `jump_pad_device` — pads de nitro (impuls vertical/direccional)
- `bouncer_device` — molls (pneumàtics)
- `grind_rail` (prop + rail) — tanques de seguretat per lliscar
- `movement_modulator` / plataformes mòbils (patrulla) — cotxes que es mouen
- `item_spawner_device` / `conditional_button` — monedes col·leccionables
- `billboard_device` / `hud_message_device` — HUD d'alçada, avisos, botiga de checkpoint
- `vending_machine_device` o `conditional_button_device` — comprar checkpoint amb monedes
- `teleporter_device` — respawn a checkpoint / reset
- `volume_device` (kill/void a baix) — reset per caiguda total
- `timer_device` — base del timer
- `leaderboard_device` — rècords (alçada / temps)
- `ambient_sound_device` / `radio_device` — música synthwave + ambient d'autopista
- `post_process_device` — bloom, grain, tint outrun (l'estètica clau)

## Riscos i com mitigar-los

| Risc | Mitigació |
|------|-----------|
| Massa frustrant → la gent marxa | Trams plans com a "xarxa"; checkpoints comprables |
| Massa fàcil → no és Only Up | Seccions 5–7 sense xarxa; salts finals exigents |
| Cheese (dreceres que trenquen el disseny) | Parets invisibles (`barrier_device`) als laterals |
| Performance amb molts props | Nanite + instancing; LODs; no partícules per tot arreu |
| Confusió de camí | Codi de color estricte (veure `visual-design.md`) |
