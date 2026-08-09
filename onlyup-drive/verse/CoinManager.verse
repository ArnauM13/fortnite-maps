using { /Fortnite.com/Devices }
using { /Fortnite.com/Characters }
using { /Fortnite.com/Game }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

# Monedes col·leccionables → moneda del mapa (per comprar checkpoints).
# Cada moneda és un trigger/botó col·locat sobre el prop de moneda.
coin_manager := class(creative_device):

    @editable CoinTriggers : []trigger_device = array{}
    @editable CoinHUD : hud_message_device = hud_message_device{}
    @editable CoinsPerPickup : int = 1

    # Saldo per jugador.
    var Balances : [agent]int = map{}

    OnBegin<override>()<suspends> : void =
        for (Coin : CoinTriggers):
            spawn { ListenCoin(Coin) }

    ListenCoin(Coin : trigger_device)<suspends> : void =
        loop:
            OptAgent := Coin.TriggeredEvent.Await()
            if (Agent := OptAgent?):
                Collect(Agent)
                # La moneda es consumeix un cop: desactiva-la a l'editor
                # o via el seu propi dispositiu en rebre l'event.
                Coin.Disable()
                break

    Collect(Agent : agent) : void =
        Current := GetBalance(Agent)
        if (set Balances[Agent] = Current + CoinsPerPickup):
            CoinHUD.Show(Agent)
            Print("Moneda! Saldo: {Current + CoinsPerPickup}")

    GetBalance(Agent : agent) : int =
        if (B := Balances[Agent]):
            return B
        return 0

    # Retorna true i descompta si el jugador té prou saldo.
    TrySpend(Agent : agent, Cost : int) : logic =
        Current := GetBalance(Agent)
        if (Current >= Cost, set Balances[Agent] = Current - Cost):
            return true
        return false
