using { /Fortnite.com/Devices }
using { /Fortnite.com/Characters }
using { /Fortnite.com/Game }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

# RECORDATORI DE "LIKE" / FAVORIT.
#
# ⚠️ IMPORTANT (política d'Epic): NO es pot detectar si un jugador ha fet like
# ni recompensar-lo per fer-ho (això és "engagement farming" i està prohibit).
# Aquest dispositiu NOMÉS mostra un recordatori amable en moments de felicitat
# (arribar a una fita, arribar al cim). No dona cap premi per fer like.
like_prompt := class(creative_device):

    @editable PromptHUD : hud_message_device = hud_message_device{}
    # Trigger de moments "alts" on l'usuari està content (cim, nou rècord...).
    @editable HappyTriggers : []trigger_device = array{}
    # Recordatori periòdic suau (opcional). 0 = desactivat.
    @editable PeriodicSeconds : float = 0.0

    OnBegin<override>()<suspends> : void =
        for (Trig : HappyTriggers):
            spawn { ListenHappy(Trig) }
        if (PeriodicSeconds > 0.0):
            spawn { PeriodicReminder() }

    ListenHappy(Trig : trigger_device)<suspends> : void =
        loop:
            OptAgent := Trig.TriggeredEvent.Await()
            if (Agent := OptAgent?):
                # "T'ho estàs passant bé? Deixa un like ❤️ i guarda el mapa!"
                PromptHUD.Show(Agent)
                Print("Recordatori de like mostrat (moment feliç).")

    PeriodicReminder()<suspends> : void =
        loop:
            Sleep(PeriodicSeconds)
            for (P : GetPlayspace().GetPlayers()):
                PromptHUD.Show(P)
