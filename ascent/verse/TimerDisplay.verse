using { /Fortnite.com/Devices }
using { /Fortnite.com/Game }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

# Manté el temps transcorregut des de l'inici de la partida.
# Activa el HUD d'avís (parpadejant) quan l'aigua és massa a prop del jugador.

timer_display := class(creative_device):

    # HUD d'avís "L'aigua és massa a prop!" — configurat al editor
    # (Es mostra/amaga quan la distància al jugador és menor que WarningDistance)
    @editable WarningHUD : hud_message_device = hud_message_device{}

    # Distància en units que activa l'avís
    @editable WarningDistance : float = 500.0

    # Referència al WaterController per llegir l'alçada actual
    @editable Water : water_controller = water_controller{}

    var IsRunning : logic = false
    var ElapsedSeconds : int = 0
    var IsWarningActive : logic = false

    # Inicia el timer — cridat pel GameManager a StartGame()
    StartTimer() : void =
        set IsRunning = true
        set ElapsedSeconds = 0
        set IsWarningActive = false
        spawn { CounterLoop() }
        Print("[Timer] Iniciat")

    # Atura el timer — cridat en victòria o derrota
    StopTimer() : void =
        set IsRunning = false
        Print("[Timer] Aturat — {GetFormattedTime()}")

    GetElapsedSeconds() : int = ElapsedSeconds

    GetFormattedTime() : string =
        let M : int = ElapsedSeconds / 60
        let S : int = ElapsedSeconds - (M * 60)
        let MinStr : string = if (M < 10) then "0{M}" else "{M}"
        let SecStr : string = if (S < 10) then "0{S}" else "{S}"
        "{MinStr}:{SecStr}"

    # Comptador intern: s'incrementa cada segon
    CounterLoop()<suspends> : void =
        loop:
            if (not IsRunning):
                break
            Sleep(1.0)
            set ElapsedSeconds = ElapsedSeconds + 1
            Print("[Timer] {GetFormattedTime()}")

    # Comprova si l'aigua és perillosa prop del jugador.
    # Cridat pel GameManager cada pocs segons amb l'alçada real del jugador.
    CheckWaterProximity(PlayerHeight : float, Agent : agent) : void =
        let WaterHeight : float = Water.GetCurrentHeight()
        let Distance : float = PlayerHeight - WaterHeight

        if (Distance <= WarningDistance and not IsWarningActive):
            set IsWarningActive = true
            WarningHUD.Show(Agent)
            Print("[Timer] AVÍS ACTIVAT — distància: {Distance}")
        else if (Distance > WarningDistance and IsWarningActive):
            set IsWarningActive = false
            WarningHUD.Hide(Agent)
            Print("[Timer] Avís desactivat — distància: {Distance}")
