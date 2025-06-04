% Missionaries and Cannibals Problem in Prolog

% State Representation: state(MissionariesLeft, CannibalsLeft, BoatSide, MissionariesRight, CannibalsRight)
% BoatSide: left or right

% Initial state: 3 missionaries, 3 cannibals on the left, boat on the left
initial_state(state(3,3,left,0,0)).

% Goal state: all missionaries and cannibals on the right
goal_state(state(0,0,right,3,3)).

% Safe state check: missionaries should never be outnumbered by cannibals
safe(state(ML, CL, _, MR, CR)) :-
    (ML >= CL ; ML = 0),
    (MR >= CR ; MR = 0).

% Possible boat moves: (Missionaries, Cannibals) combinations
move(2,0). % Two missionaries
move(0,2). % Two cannibals
move(1,1). % One missionary, one cannibal
move(1,0). % One missionary
move(0,1). % One cannibal

% Transition between states
transition(state(ML, CL, left, MR, CR), state(ML2, CL2, right, MR2, CR2)) :-
    move(M, C),
    ML >= M, CL >= C,
    ML2 is ML - M, CL2 is CL - C,
    MR2 is MR + M, CR2 is CR + C,
    safe(state(ML2, CL2, right, MR2, CR2)).

transition(state(ML, CL, right, MR, CR), state(ML2, CL2, left, MR2, CR2)) :-
    move(M, C),
    MR >= M, CR >= C,
    MR2 is MR - M, CR2 is CR - C,
    ML2 is ML + M, CL2 is CL + C,
    safe(state(ML2, CL2, left, MR2, CR2)).

% Depth-first search for solution
solve(State, Path) :-
    dfs(State, [], Path).

dfs(State, Visited, [State]) :-
    goal_state(State).

dfs(State, Visited, [State | Path]) :-
    transition(State, NextState),
    \+ member(NextState, Visited),  % Αποφυγή επαναλήψεων
    dfs(NextState, [NextState | Visited], Path).


% Find a solution
solve_missionaries_cannibals(Path) :-
    initial_state(StartState),
    solve(StartState, Path).
