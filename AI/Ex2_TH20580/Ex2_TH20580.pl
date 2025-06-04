% Βοηθητικά predicates
member(X, [X|_]).
member(X, [_|T]) :- member(X, T).

% Ελέγχει αν ένα αντικείμενο έχει κάτι πάνω του
has_on_top(X, State) :- member(on(_, X), State).

% Εύρεση έγκυρης μετακίνησης move(X,Y)
move(State, on(X,Y), NewState) :-
    member(X, [a,b,c]),
    member(Y, [a,b,c,t]),
    X \= Y,
    \+ has_on_top(X, State),
    (Y = t ; (\+ has_on_top(Y, State))),
    select(on(X, Z), State, TempState), % Αφαίρεσε την παλιά θέση του X
    \+ member(on(X,Y), TempState), % Απόφυγε επαναλαμβανόμενες καταστάσεις
    NewState = [on(X,Y)|TempState].

% Τελική κατάσταση
goal([on(a,b), on(b,c), on(c,t)]).

% BFS
bfs([[State, Path]|_], Path) :- goal(State).
bfs([[State, Path]|Rest], Solution) :-
    findall([NewState, [Move|Path]],
            (move(State, Move, NewState), \+ member([NewState,_], Rest)),
            NewPaths),
    append(Rest, NewPaths, Queue),
    bfs(Queue, Solution).

solve_bfs(Steps) :-
    InitialState = [on(a, c), on(b, t), on(c, t)],
    bfs([[InitialState, []]], RevSteps),
    reverse(RevSteps, Steps).

% dfs με visited states για να αποφεύγονται κύκλοι
dfs([State, Path], _, Path) :- goal(State).
dfs([State, Path], Visited, Solution) :-
    move(State, Move, NewState),
    \+ member(NewState, Visited),  % αποφυγή κύκλων
    dfs([NewState, [Move|Path]], [NewState|Visited], Solution).

solve_dfs(Steps) :-
    InitialState = [on(a, c), on(b, t), on(c, t)],
    dfs([InitialState, []], [InitialState], RevSteps),
    reverse(RevSteps, Steps).

