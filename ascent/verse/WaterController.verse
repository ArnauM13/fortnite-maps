using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /Verse.org/Native }
using { /UnrealEngine.com/Temporary/Diagnostics }

# WaterController — Controla la pujada de l'aigua/lava
# Mou el volum de dany cap amunt gradualment

water_controller := class(creative_device):

    # Volum de dany que representa l'aigua (mata el jugador)
    @editable DamageVolume : damage_volume_device = damage_volume_device{}

    # Velocitat de pujada en unitats per segon
    @editable RiseSpeed : float = 2.0

    # Alçada màxima que pot arribar l'aigua (just sota el cim)
    @editable MaxHeight : float = 2800.0

    # Estat intern
    var IsRising : logic = false
    var CurrentHeight : float = 0.0

    # Inicia la pujada d'aigua
    StartWaterRise() : void =
        set IsRising = true
        Print("Aigua: Pujada iniciada a {RiseSpeed} u/s")
        spawn { RiseLoop() }

    # Atura la pujada
    StopWaterRise() : void =
        set IsRising = false
        Print("Aigua: Pujada aturada")

    # Bucle principal de pujada
    RiseLoop()<suspends> : void =
        loop:
            if (not IsRising):
                break
            if (CurrentHeight >= MaxHeight):
                Print("Aigua: Alçada màxima assolida")
                break

            # Actualitzar alçada cada segon
            # TODO: moure el DamageVolume a CurrentHeight via transform
            set CurrentHeight = CurrentHeight + RiseSpeed
            Sleep(1.0)
