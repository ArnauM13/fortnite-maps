using { /Fortnite.com/Devices }
using { /Fortnite.com/Characters }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

# heat_system  (EVOLUCIÓ v2 — sistema original)
# Converteix el valor 💠 que un jugador porta a la ronda en "calor" (Heat) i,
# en passar llindars, l'exposa als altres: avisos, ping al minimapa i rastre
# visible. Fer que la cobdícia sigui VISIBLE és el nucli de l'evolució.
#
# No copiat de cap mapa: llegeix el valor de ronda de l'estat compartit i
# n'actualitza els efectes per jugador en un bucle propi.

heat_tier := enum:
    Cold      # invisible
    Warm      # avís només per a tu
    Hot       # ping al minimapa de tothom
    Blazing   # ping constant + rastre visible

heat_system := class(creative_device):

    # Llindars de valor (💠) per pujar de nivell de Heat.
    @editable WarmThreshold : int = 100
    @editable HotThreshold : int = 300
    @editable BlazingThreshold : int = 600

    # Cada quants segons es reavalua el Heat de cada jugador.
    @editable TickSeconds : float = 1.0

    # Avís HUD per al portador quan puja de nivell.
    @editable HeatHUD : hud_message_device = hud_message_device{}

    # Indicadors de minimapa (pool). S'activen per marcar els jugadors "calents".
    # A UEFN, cada map_indicator es lliga a un jugador via Enable/Disable + tracking.
    @editable MapIndicators : []map_indicator_device = array{}

    # Rastre visible (VFX) que segueix els jugadors "roents".
    @editable BlazingVFX : []vfx_creator_device = array{}

    State : extraction_state = extraction_state{}

    # Nivell de Heat actual per jugador, per detectar canvis.
    var CurrentTier : [player]heat_tier = map{}

    OnBegin<override>()<suspends>:void=
        State.InitializeAll(GetPlayspace().GetPlayers())
        loop:
            for (Player : GetPlayspace().GetPlayers()):
                EvaluateHeat(Player)
            Sleep(TickSeconds)

    # Calcula el nivell de Heat d'un jugador segons el valor que porta.
    TierFor(Value : int) : heat_tier =
        if (Value >= BlazingThreshold) then heat_tier.Blazing
        else if (Value >= HotThreshold) then heat_tier.Hot
        else if (Value >= WarmThreshold) then heat_tier.Warm
        else heat_tier.Cold

    EvaluateHeat(Player : player) : void =
        Value := State.GetRunValue(Player)
        NewTier := TierFor(Value)
        OldTier := if (T := CurrentTier[Player]) then T else heat_tier.Cold
        if (NewTier <> OldTier):
            if (set CurrentTier[Player] = NewTier) {}
            ApplyTier(Player, NewTier)

    # Aplica els efectes visibles del nou nivell de Heat.
    ApplyTier(Player : player, Tier : heat_tier) : void =
        case (Tier):
            heat_tier.Cold =>
                SetExposure(Player, false, false)
                Print("Heat: jugador FRED — invisible")
            heat_tier.Warm =>
                SetExposure(Player, false, false)
                HeatHUD.Show(Player)
                Print("Heat: jugador TEBI — avís propi")
            heat_tier.Hot =>
                SetExposure(Player, true, false)
                HeatHUD.Show(Player)
                Print("Heat: jugador CALENT — ping al mapa de tothom")
            heat_tier.Blazing =>
                SetExposure(Player, true, true)
                HeatHUD.Show(Player)
                Print("Heat: jugador ROENT — ping constant + rastre visible")

    # Activa/desactiva l'exposició d'un jugador (minimapa i/o rastre VFX).
    # Assigna un indicador i un VFX per jugador a l'editor; aquí els commutem.
    SetExposure(Player : player, Pinged : logic, Trailing : logic) : void =
        if (Index := GetPlayerIndex[Player]):
            if (Indicator := MapIndicators[Index]):
                if (Pinged?):
                    Indicator.SetTarget(Player)
                    Indicator.Show(Player)
                else:
                    Indicator.Hide(Player)
            if (VFX := BlazingVFX[Index]):
                if (Trailing?):
                    VFX.Enable()
                else:
                    VFX.Disable()

    # Índex estable del jugador dins la llista de la partida, per emparellar-lo
    # amb el seu indicador/VFX dedicat.
    GetPlayerIndex(Player : player) : ?int =
        for (Index -> P : GetPlayspace().GetPlayers()):
            if (P = Player):
                return option{Index}
        return false
