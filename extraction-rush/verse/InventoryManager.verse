using { /Fortnite.com/Devices }
using { /Fortnite.com/Characters }
using { /Fortnite.com/Game }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

# InventoryManager
# Gestiona el botí del jugador amb dues capes:
#   - RunLoot: valor recollit DURANT la ronda actual (es perd si mors).
#   - Stash:  valor persistent guardat a l'estança (mai es perd; sobreviu entre partides).
# En extreure amb èxit → RunLoot passa a Stash. En morir → RunLoot s'esborra.

# Dades persistents de l'estança del jugador.
# El tipus ha de ser 'persistable' per guardar-se entre sessions.
stash_data := class<final><persistable>:
    Value : int = 0          # Valor total acumulat a l'estança
    RunsExtracted : int = 0   # Nombre de rondes extretes amb èxit

# Mapa persistent a nivell de mòdul (una entrada per jugador)
var StashMap : weak_map(player, stash_data) = map{}

inventory_manager := class(creative_device):

    # HUD que mostra el valor actual (ronda + estança)
    @editable ValueHUD : hud_message_device = hud_message_device{}

    # Valor recollit a la ronda actual, per jugador (NO persistent — es perd en morir)
    var RunLoot : [player]int = map{}

    # Afegeix valor a la ronda actual quan el jugador recull un objecte
    AddRunLoot(Player : player, Amount : int) : void =
        let Current : int = GetRunLoot(Player)
        set RunLoot = ConcatenatePlayerInt(RunLoot, Player, Current + Amount)
        Print("Inventari: +{Amount} valor de ronda (total ronda: {Current + Amount})")

    # Retorna el valor de la ronda actual del jugador
    GetRunLoot(Player : player) : int =
        if (V := RunLoot[Player]):
            return V
        return 0

    # Retorna el valor persistent de l'estança
    GetStashValue(Player : player) : int =
        if (Data := StashMap[Player]):
            return Data.Value
        return 0

    # EXTRACCIÓ EXITOSA: passa el botí de la ronda a l'estança persistent.
    # Retorna el valor assegurat en aquesta extracció.
    CommitRunLoot(Player : player) : int =
        let Earned : int = GetRunLoot(Player)
        let PrevValue : int = GetStashValue(Player)
        let PrevRuns : int = if (D := StashMap[Player]) then D.RunsExtracted else 0

        # Actualitzar l'estança persistent
        set StashMap[Player] = stash_data:
            Value := PrevValue + Earned
            RunsExtracted := PrevRuns + 1

        # Netejar el botí de la ronda (ja està assegurat)
        set RunLoot = ConcatenatePlayerInt(RunLoot, Player, 0)
        Print("Inventari: {Earned} valor assegurat a l'estança (total: {PrevValue + Earned})")
        return Earned

    # MORT: el jugador perd tot el botí de la ronda actual (l'estança es conserva).
    LoseRunLoot(Player : player) : void =
        let Lost : int = GetRunLoot(Player)
        set RunLoot = ConcatenatePlayerInt(RunLoot, Player, 0)
        Print("Inventari: {Lost} valor PERDUT per mort (estança intacta)")

    # Comprova si el jugador es pot permetre una compra amb el valor de l'estança
    CanAfford(Player : player, Cost : int) : logic =
        return GetStashValue(Player) >= Cost

    # Gasta valor de l'estança (compra de loadout, keycards, ranures...)
    SpendStash(Player : player, Cost : int) : logic =
        if (GetStashValue(Player) >= Cost):
            let PrevRuns : int = if (D := StashMap[Player]) then D.RunsExtracted else 0
            set StashMap[Player] = stash_data:
                Value := GetStashValue(Player) - Cost
                RunsExtracted := PrevRuns
            Print("Inventari: -{Cost} valor gastat de l'estança")
            return true
        return false

    # --- Helper: actualitza el valor d'un jugador dins un [player]int ---
    ConcatenatePlayerInt(M : [player]int, Player : player, NewValue : int) : [player]int =
        var Result : [player]int = map{}
        for (Key -> Val : M, not Key = Player):
            set Result = ConcatMaps(Result, Key, Val)
        set Result = ConcatMaps(Result, Player, NewValue)
        return Result

    ConcatMaps(M : [player]int, K : player, V : int) : [player]int =
        var Out : [player]int = M
        if (set Out[K] = V) {}
        return Out
