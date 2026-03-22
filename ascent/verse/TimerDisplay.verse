using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

# TimerDisplay — Timer en pantalla per speedrun
# Mostra el temps transcorregut des de l'inici

timer_display := class(creative_device):

    # HUD message device per mostrar el temps
    @editable HUDMessage : hud_message_device = hud_message_device{}

    # Estat intern
    var IsRunning : logic = false
    var ElapsedSeconds : int = 0

    # Inicia el timer
    StartTimer() : void =
        set IsRunning = true
        set ElapsedSeconds = 0
        spawn { TimerLoop() }

    # Atura el timer
    StopTimer() : void =
        set IsRunning = false

    # Retorna el temps transcorregut en segons
    GetElapsedTime() : int =
        return ElapsedSeconds

    # Bucle que actualitza el timer cada segon
    TimerLoop()<suspends> : void =
        loop:
            if (not IsRunning):
                break
            Sleep(1.0)
            set ElapsedSeconds = ElapsedSeconds + 1
            UpdateHUD()

    # Actualitza el missatge HUD amb el temps formatat
    UpdateHUD() : void =
        let Minutes : int = ElapsedSeconds / 60
        let Seconds : int = ElapsedSeconds - (Minutes * 60)
        # TODO: formatar i enviar al HUDMessage device
        Print("Temps: {Minutes}:{Seconds}")
