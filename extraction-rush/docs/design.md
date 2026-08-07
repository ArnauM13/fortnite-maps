# EXTRACTION RUSH — Game Design Document

## Premissa

Un extraction shooter de rondes curtes. El jugador desplega ("deploy") en un mapa dividit en 3 anells de perill creixent. Ha de recollir loot (armes i objectes de valor) i **arribar viu a un punt d'extracció** abans que la tempesta tanqui la zona. El botí extret es guarda de forma persistent i es pot reinvertir; el botí perdut per mort desapareix. La tensió d'arriscar-ho tot és el nucli emocional del joc.

## Bucle de joc (Game Loop)

```
Lobby → DEPLOY → RAID (loot + PvPvE) → EXTRACCIÓ → RESULTAT → Lobby
          ↑                                  │
          │         (mort = perds el botí ───┘ i tornes al lobby)
          └──────────── (extracció OK = guardes el botí a l'estança)
```

Fases d'una ronda:

1. **Deploy (0:00–0:20)** — els jugadors cauen al mapa amb loadout base. Immunitat breu.
2. **Raid (0:20–5:00)** — fase de looting i combat. La tempesta encara no es mou.
3. **Tancament (5:00–7:00)** — la tempesta comença a xuclar; els anells exteriors deixen de ser segurs. S'obren els punts d'extracció.
4. **Extracció final (7:00–8:00)** — només queda l'extracció central. Últim que escapa s'endú un bonus.

## Paràmetres clau

| Paràmetre | Valor inicial | Notes |
|-----------|--------------|-------|
| Jugadors per ronda | 16–24 | Solo / Duos / Trios |
| Durada de la ronda | 6–8 min | Ajustable amb testing |
| Immunitat inicial (deploy) | 5 s | Evita spawn-kills |
| Temps de canalització d'extracció | 8 s | Vulnerable mentre extreus |
| Punts d'extracció simultanis | 3 → 2 → 1 | Es van reduint amb el temps |
| Ranura d'objectes de valor | 6 | Límit de botí transportable |
| % del botí que es perd en morir | 100% | Del que portaves a sobre |

## Sensació que volem transmetre

- **Cobdícia** — "una caixa més abans d'extreure" ha de ser una temptació constant.
- **Tensió** — el compte enrere de l'extracció i el so de la tempesta creen pressió.
- **Recompensa persistent** — veure l'estança créixer partida rere partida.
- **Moments virals** — extreure amb 1 HP mentre et disparen = clip compartible.

## Economia i progressió (resum)

- El **valor** (💠) és la moneda: cada objecte extret suma valor a l'estança.
- Amb valor es compra millor **loadout de deploy** (entrar amb més que el mínim).
- **Missions diàries** donen XP → nivells de temporada → recompenses cosmètiques.
- Detall complet a [`economy.md`](./economy.md).

## Dispositius UEFN necessaris

- `player_spawner_device` — punts de deploy
- `item_spawner_device` / `item_granter_device` — loot per nivells
- `capture_area_device` — zones de canalització d'extracció
- `timer_device` — timer de ronda i de fases
- `storm_controller_device` — tempesta que tanca la zona
- `mutator_zone_device` — marcar anells de perill / bonus loot
- `conditional_button_device` — activar extracció
- `hud_message_device` — feedback (extracció, avisos, botí)
- `elimination_manager_device` — gestionar morts i drop de botí
- `leaderboard_device` — valor extret per jugador
- `class_designer_device` — loadouts de deploy
- `vending_machine_device` — botiga d'upgrades amb valor
- `barrier_device` — portes de La Bòveda
