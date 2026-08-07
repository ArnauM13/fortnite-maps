# EXTRACTION RUSH — L'evolució (v2)

## D'on venim

La **v1** va posar els fonaments reutilitzant infraestructura provada (persistència,
leaderboard, HUD i reset del mapa Naufragi). Això ens dona una base sòlida, però
un extraction shooter que només fa "loot → escapa" ja existeix mil cops.

La **v2 és l'evolució**: sistemes **originals**, no copiats de cap mapa anterior,
construïts al voltant d'una sola idea forta que ho lliga tot.

## La tesi de disseny

> **La cobdícia s'ha de VEURE i s'ha de poder ROBAR.**

En la majoria d'extraction shooters, el botí que portes és invisible per als
altres i, si mors, simplement desapareix. Això desaprofita la millor font de
tensió del gènere. A EXTRACTION RUSH v2, cada unitat de valor que acumules:

1. **Et fa més visible** (t'exposa) — sistema de *Heat*.
2. **Es pot robar si caus** — sistema de *bosses de botí*.
3. **Fa que escapar sigui una aposta pública** — *balises d'extracció*.
4. **Ve de la teva pròpia inversió persistent** — *botiga de loadout*.

El resultat: cada decisió de "una caixa més" té conseqüències visibles i
immediates per a tu i per als altres jugadors. Això genera els moments virals
que retenen una base activa.

## Els 4 pilars de l'evolució

### 1. Heat — el valor et pinta a sobre (`heat_system.verse`)
Com més valor 💠 portes a la ronda, més "calor" generes. En passar llindars:

| Heat | Valor en risc | Efecte |
|------|---------------|--------|
| ❄️ Fred | < 100 | Invisible al mapa |
| 🟡 Tebi | 100–299 | Avís només per a tu |
| 🟠 Calent | 300–599 | **Ping al minimapa de tothom** cada X s |
| 🔴 Roent | 600+ | Ping constant + rastre visible |

Portar el botí premium de La Bòveda et converteix en la presa més cobejada del
mapa. La recompensa i el risc pugen junts, de manera **visible**.

### 2. Bosses de botí — les morts transfereixen riquesa (`squad_manager.verse`)
Quan un jugador mor **no perd el botí en el buit**: deixa una **bossa** al terra
amb tot el valor que portava. Qualsevol que la reculli l'afegeix al seu propi
botí de ronda. Matar algú carregat és, literalment, robar-li la caixa forta.

En modes d'equip (duos/trios) s'hi afegeix l'estat **abatut + reanimació**: un
company et pot aixecar abans de la mort definitiva, però mentre et reanima està
exposat. Decisió d'equip sota pressió.

### 3. Balises d'extracció — escapar és una aposta pública (`beacon_manager.verse`)
A més dels punts fixos, un jugador pot **cridar una balisa** i obrir una
extracció temporal al seu lloc actual. Però la balisa **avisa tothom** durant uns
segons: has muntat la teva sortida... i has anunciat exactament on ets amb el
botí a sobre. Risc calculat.

### 4. Botiga de loadout — la teva inversió torna a la ronda (`loadout_shop.verse`)
Al lobby, gastes el valor de l'estança per entrar més fort (loadouts per nivells)
i per **assegurar** una arma (si mors, la recuperes). Tanca el bucle: el que
extreus finança el que arrisques la ronda següent.

## Per què és una evolució i no un remix

| Aspecte | v1 (fonament) | v2 (evolució) |
|---------|---------------|---------------|
| Botí en morir | Desapareix | **Es queda al terra, robable** |
| Valor que portes | Invisible | **Et marca al mapa (Heat)** |
| Extracció | Punts fixos rotatius | + **balises cridables** públiques |
| Economia | Estança que puja | **Reinversió en loadout + assegurança** |
| Origen del codi | Copiat del Naufragi | **Sistemes propis i nous** |

## Nous dispositius UEFN que caldran

- `vfx_creator_device` / `visual_effect_powerup` — rastre visible del Heat roent
- `map_indicator_device` — pings al minimapa
- `item_spawner_device` (pool) — bosses de botí al terra
- `conditional_button_device` — cridar balisa / reanimar
- `vending_machine_device` / `class_designer_device` — botiga de loadout
- `item_granter_device` — assegurança d'armes
