using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

# extraction_leaderboard
# Adaptació directa de 'climb_leaderboard.verse' (OnlyUp Naufragi): en comptes
# d'ordenar per alçada, ordena els jugadors pel VALOR total de la seva estança.
# Mostra el top d'operatius en una fila de Billboard Devices col·locats al lobby
# perquè es vegi el rànquing abans/després de cada ronda.
# Assigna 3–5 billboards a Leaderboards, index 0 = rang més alt.

extraction_leaderboard := class(creative_device):

    @editable
    Leaderboards:[]billboard_device = array{}

    # Cada quants segons es refresca el marcador.
    @editable
    RefreshIntervalSeconds:float = 5.0

    State:extraction_state = extraction_state{}

    RankMessage<localizes>(Rank:int, Operative:agent, Value:int):message = "#{Rank}  {Operative}  -  {Value} 💠"
    EmptyRankMessage<localizes>(Rank:int):message = "#{Rank}  ---"

    OnBegin<override>()<suspends>:void=
        State.InitializeAll(GetPlayspace().GetPlayers())
        loop:
            RefreshLeaderboard(GetPlayspace().GetPlayers())
            Sleep(RefreshIntervalSeconds)

    RefreshLeaderboard(Players:[]player):void=
        State.InitializeAll(Players)
        AllStash := State.GetAllStash(Players)
        Sorted := SortByValueDescending(AllStash)
        for (Index -> Board : Leaderboards):
            if (Entry := Sorted[Index]):
                Board.SetText(RankMessage(Index + 1, Entry.Player, Entry.Stash.Value))
            else:
                Board.SetText(EmptyRankMessage(Index + 1))

    # Insertion sort — pocs jugadors/billboards, simple i sense dependències
    # (mateixa estructura que el sort del Naufragi).
    SortByValueDescending(Entries:[]player_and_stash):[]player_and_stash=
        var Sorted:[]player_and_stash = array{}
        for (Entry : Entries):
            set Sorted = InsertSorted(Sorted, Entry)
        Sorted

    InsertSorted(Sorted:[]player_and_stash, NewEntry:player_and_stash):[]player_and_stash=
        var Result:[]player_and_stash = array{}
        var Inserted:logic = false
        for (Existing : Sorted):
            if (not Inserted?, NewEntry.Stash.Value > Existing.Stash.Value):
                set Result += array{NewEntry}
                set Inserted = true
            set Result += array{Existing}
        if (not Inserted?):
            set Result += array{NewEntry}
        Result
