# ASCENT — Game Design Document

## Premissa

Una torre/ciutat gegant s'enfonsa lentament. El jugador ha de pujar des del soterrani fins al cim mentre l'aigua puja des de baix. L'objectiu és arribar al cim abans que l'aigua t'alcanci.

## Bucle de joc (Game Loop)

```
Inici → Zona 1 → Checkpoint → Zona 2 → Checkpoint → ... → Zona 5 → FI
                                    ↑
                          (mort = tornar al darrer checkpoint)
```

## Paràmetres clau

| Paràmetre | Valor inicial | Notes |
|-----------|--------------|-------|
| Velocitat pujada aigua | 2 u/s | Ajustable per dificultat |
| Alçada total mapa | ~3000 unitats | Unreal units |
| Temps objectiu (speedrun) | ~10 min | A ajustar amb testing |
| Jugadors simultanis | 1-4 | Multiplayer race opcional |

## Sensació que volem transmetre

- **Urgència** — l'aigua sempre et recorda que no pots parar
- **Progrés** — cada checkpoint és una victòria petita
- **Varietat** — cada zona es veu i es juga diferent
- **Satisfacció** — arribar al cim ha de sentir-se épic

## Dispositius UEFN necessaris

- `checkpoint_device` — x5 (un per zona)
- `damage_volume` — per l'aigua (mort instantània)
- `mutator_zone_device` — canviar gravetat/velocitat per zones
- `timer_device` — base pel HUD timer
- `leaderboard_device` — millors temps
- `elimination_manager_device` — gestionar morts
- `jump_pad_device` — salts especials
- `grind_rail_device` — rails de lliscament
- `ambient_sound_device` — so ambient per zona
