using { /Fortnite.com/Devices }
using { /Fortnite.com/Game }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

# TimerDisplay
# Mostra el temps transcorregut en pantalla (HUD) des de l'inici de la partida.
# Activa un avís quan l'aigua és perillosa prop del jugador.

timer_display := class(creative_device):

    # HUD principal per al timer (visible sempre durant la partida)
    @editable TimerHUD : hud_message_device = hud_message_device{}

    # HUD d'avís quan l'aigua és massa a prop
    @editable WarningHUD : hud_message_device = hud_message_device{}

    # Distància en units entre el jugador i l'aigua que activa l'avís
    @editable WarningDistance : float = 500.0

    # Referència al WaterController per llegir l'alçada actual
    @editable Water : water_controller = water_controller{}

    # --- Estat intern ---
    var IsRunning : logic = false
    var ElapsedSeconds : int = 0
    var IsWarningActive : logic = false

    # Inicia el timer — cridat pel GameManager a l'inici de la partida
    StartTimer() : void =
        set IsRunning = true
        set ElapsedSeconds = 0
        set IsWarningActive = false
        spawn { TimerLoop() }

    # Atura el timer — cridat en victòria
    StopTimer() : void =
        set IsRunning = false

    # Retorna el temps total en segons (per al LeaderboardManager)
    GetElapsedSeconds() : int = ElapsedSeconds

    # Retorna el temps formatat com "MM:SS"
    GetFormattedTime() : string =
        let Minutes : int = ElapsedSeconds / 60
        let Seconds : int = ElapsedSeconds - (Minutes * 60)
        let MinStr : string = if (Minutes < 10) then "0{Minutes}" else "{Minutes}"
        let SecStr : string = if (Seconds < 10) then "0{Seconds}" else "{Seconds}"
        return "{MinStr}:{SecStr}"

    # Bucle principal: s'actualitza cada segon
    TimerLoop()<suspends> : void =
        loop:
            if (not IsRunning):
                break
            Sleep(1.0)
            set ElapsedSeconds = ElapsedSeconds + 1
            let TimeStr : string = GetFormattedTime()
            Print("ASCENT | {TimeStr}")

    # Comprova si l'aigua és perillosa prop del jugador i activa l'avís
    # Cridat externament pel GameManager cada pocs segons
    CheckWaterProximity(PlayerHeight : float) : void =
        let WaterHeight : float = Water.GetCurrentHeight()
        let Distance : float = PlayerHeight - WaterHeight

        if (Distance <= WarningDistance and not IsWarningActive):
            set IsWarningActive = true
            Print("AVÍS: L'aigua és massa a prop!")
        else if (Distance > WarningDistance and IsWarningActive):
            set IsWarningActive = false
            Print("Avís desactivat — jugador segur")
