using { /Fortnite.com/Devices }
using { /Fortnite.com/Characters }
using { /Fortnite.com/Game }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

# FITXES (⚡) — moneda de partida. Tipus: estàndard(1), risc(3), mòbil(2), secreta(5).
# Aplica un multiplicador de ratxa "sense caure" sobre el valor recollit.
# Veure economy.md per als valors i quantitats.
coin_manager := class(creative_device):

    @editable StandardCoins : []trigger_device = array{}   # valor 1
    @editable RiskCoins : []trigger_device = array{}       # valor 3
    @editable MovingCoins : []trigger_device = array{}     # valor 2
    @editable SecretCoins : []trigger_device = array{}     # valor 5
    @editable CoinHUD : hud_message_device = hud_message_device{}
    @editable StreakHUD : hud_message_device = hud_message_device{}

    StandardValue : int = 1
    RiskValue : int = 3
    MovingValue : int = 2
    SecretValue : int = 5

    # Saldo de fitxes i comptador de secretes, per jugador.
    var Balances : [agent]int = map{}
    var SecretsFound : [agent]int = map{}

    # Multiplicador de ratxa (x100): 100 = x1, 150 = x1.5, 200 = x2.
    var StreakMult : [agent]int = map{}

    OnBegin<override>()<suspends> : void =
        ListenType(StandardCoins, StandardValue, false)
        ListenType(RiskCoins, RiskValue, false)
        ListenType(MovingCoins, MovingValue, false)
        ListenType(SecretCoins, SecretValue, true)

    ListenType(Coins : []trigger_device, Value : int, IsSecret : logic) : void =
        for (Coin : Coins):
            spawn { ListenCoin(Coin, Value, IsSecret) }

    ListenCoin(Coin : trigger_device, Value : int, IsSecret : logic)<suspends> : void =
        OptAgent := Coin.TriggeredEvent.Await()
        if (Agent := OptAgent?):
            Collect(Agent, Value, IsSecret)
            Coin.Disable()

    Collect(Agent : agent, Value : int, IsSecret : logic) : void =
        Awarded := (Value * GetStreak(Agent)) / 100
        Current := GetBalance(Agent)
        if (set Balances[Agent] = Current + Awarded):
            CoinHUD.Show(Agent)
        if (IsSecret?):
            SC := GetSecrets(Agent)
            if (set SecretsFound[Agent] = SC + 1):
                Print("Secreta trobada! ({SC + 1})")

    # Cridat per HeightTracker quan el jugador entra a una secció nova (bonus).
    AwardSectionBonus(Agent : agent, Bonus : int) : void =
        Current := GetBalance(Agent)
        if (set Balances[Agent] = Current + Bonus):
            CoinHUD.Show(Agent)

    # Ratxa: puja cada tram net; es reinicia en caure (cridat per FallResetManager).
    IncreaseStreak(Agent : agent) : void =
        Now := GetStreak(Agent)
        Next := if (Now < 200) then Now + 50 else 200
        if (set StreakMult[Agent] = Next):
            StreakHUD.Show(Agent)

    ResetStreak(Agent : agent) : void =
        if (set StreakMult[Agent] = 100) {}

    GetStreak(Agent : agent) : int =
        if (S := StreakMult[Agent], S > 0):
            return S
        return 100

    GetBalance(Agent : agent) : int =
        if (B := Balances[Agent]):
            return B
        return 0

    GetSecrets(Agent : agent) : int =
        if (S := SecretsFound[Agent]):
            return S
        return 0

    # Retorna true i descompta si hi ha prou saldo (checkpoints, potenciadors).
    TrySpend(Agent : agent, Cost : int) : logic =
        Current := GetBalance(Agent)
        if (Current >= Cost, set Balances[Agent] = Current - Cost):
            return true
        return false
