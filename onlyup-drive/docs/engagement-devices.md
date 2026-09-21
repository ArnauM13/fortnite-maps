# ONLY UP: DRIVE — Dispositius d'Engagement (pantalla, like, botiga privada)

Tres peces que reforcen que la gent es quedi i torni. Cadascuna té el seu `.verse`.

---

## 1. Leaderboard EN PANTALLA (HUD viu) — `LiveLeaderboardHUD.verse`

Diferent de les carteleres físiques del hub (`leaderboard_manager`): això és un **HUD ancorat a la pantalla** que es veu **mentre escales**, en directe.

- Mostra el **top-3 d'alçada** de la partida + **la teva posició** (p. ex. "TU · 3r · 2140m").
- S'actualitza cada ~3s.
- En cursa oberta (fins a 16) és el que crea la tensió "aquell va per sobre meu" → t'empeny a seguir.

**Muntatge:** 4 `hud_message_device` ancorats a pantalla (Line1–3 + YourLine). Cabla `Heights` al `height_tracker`. L'ordre/text real es composa a UEFN a partir de `GetPlayers()` + alçada.

> Convé mostrar-lo discret (cantonada) per no tapar el parkour.

---

## 2. Recordatori de LIKE / FAVORIT — `LikePrompt.verse`

⚠️ **Llegeix això primer.** A Fortnite/UEFN **no es pot detectar** si algú ha fet like o ha guardat l'illa, i **està prohibit recompensar** cap acció d'engagement (like, favorit, seguir...). Això és "engagement farming" i pot fer-te fora del programa. Per tant:

- **El que SÍ pots fer (i fa aquest dispositiu):** mostrar un **recordatori amable** en moments de felicitat — arribar al cim, batre un rècord — del tipus *"T'ho passes bé? Deixa un like ❤️ i guarda el mapa!"*.
- **El que NO pots fer:** donar monedes/KM/avantatges per fer like, ni bloquejar contingut fins que facin like.

**Muntatge:** un `hud_message_device` amb el text del recordatori + una llista de `HappyTriggers` (cim, nou rècord). `PeriodicSeconds` opcional per a un recordatori suau cada X (deixa'l a 0 si no el vols; no siguis pesat).

> El millor "like" s'aconsegueix amb un bon moment de cim + botó de compartir del propi Fortnite. El recordatori només ajuda.

---

## 3. BOTIGA PRIVADA (per jugador) — `PrivateShop.verse`

Una botiga **personal**: cada jugador té el **seu** inventari de compres persistents, i el que compra **no afecta els altres**. Gasta **KM** 🏁 (`meta_progress`).

Articles (cosmètics/permanents, ampliables):

| Article | id | Cost KM |
|---------|----|---------|
| Rastre de neó rosa | `trail_pink` | 60 |
| Rastre de neó cian | `trail_cyan` | 60 |
| Skin del cotxe-trofeu | `trophy_skin` | 120 |
| Vehicle d'entrada a l'spawn | `entrance_car` | 100 |
| Emote al cim | `summit_emote` | 80 |

- Les compres es desen per compte (`weak_map` persistent) → hi són la pròxima sessió.
- L'efecte cosmètic s'activa **només per a aquell jugador** a UEFN (rastre, skin, emote).
- `HasItem(Player, id)` permet a altres sistemes saber què té equipat.

**Muntatge:** col·loca `private_shop`, un `button_device` per article i cabla `Meta` + `Feedback`. Situa-la al **garatge del hub** (i, si vols, un accés ràpid al cim).

> Diferència amb el Garatge d'upgrades (`garage_upgrades`): el Garatge millora estadístiques ("+1"); la Botiga Privada ven **cosmètics/desbloquejos** permanents. Les dues són per jugador.

---

## Resum

| Dispositiu | Què fa | Nota clau |
|------------|--------|-----------|
| `LiveLeaderboardHUD` | Rànquing d'alçada en pantalla, en directe | Discret, cantonada |
| `LikePrompt` | Recordatori de like en moments alts | ❗ Mai recompensar-lo (política) |
| `PrivateShop` | Botiga personal de cosmètics amb KM | Compres persistents per compte |
