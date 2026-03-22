# Fortnite Maps — UEFN Collection

Col·lecció de mapes per Fortnite creats amb UEFN (Unreal Editor for Fortnite) i Verse.

## Mapes

| Mapa | Tipus | Estat | Codi |
|------|-------|-------|------|
| [ASCENT](./ascent/) | Parkour vertical | En desenvolupament | — |

## Tecnologia

- **UEFN** — Unreal Editor for Fortnite
- **Verse** — Llenguatge de scripting d'Epic Games
- **Unreal Engine 5** — Nanite, Lumen

## Estructura

```
fortnite-maps/
├── ascent/          ← Parkour vertical (torre que s'enfonsa)
├── _template/       ← Plantilla base per nous mapes
└── README.md
```

## Crear un nou mapa

1. Copia la carpeta `_template/` amb el nom del nou mapa
2. Omple `docs/design.md` amb el concepte
3. Implementa els scripts Verse a `verse/`
4. Crea el projecte UEFN i importa els scripts
