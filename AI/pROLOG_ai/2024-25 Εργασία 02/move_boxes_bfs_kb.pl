

box(a).
box(b).
box(c).
table_(t).

%A quick and dirty way to check if two 3-element sets have the same elements.
same([X,Y,Z],[A,B,C]):-
  member(X,[A,B,C]),
  member(Y,[A,B,C]),
  member(Z,[A,B,C]),
  member(A,[X,Y,Z]),
  member(B,[X,Y,Z]),
  member(C,[X,Y,Z]).
%Helper function that asserts each "on " of a state to KB
list_to_kb([]):-compute_free(a),compute_free(b),compute_free(c).
list_to_kb([H|T]):-assert(H),list_to_kb(T).

%inserts a "free" fact if item not on top of it
compute_free(Item):-
  \+on(_,Item),
  assert(free(Item));
  true.

kb_to_list(R):-
  bagof(on(X,Y),on(X,Y),Temp),
  same(R,Temp).

%moves box from table to another box
%Item is the box to be moved,  Sa is the initial state and St is the final state
move_box(Item,Base):-
  %if
  table_(Base),           %Base is table
  \+table_(Item),
  free(Item),             %Item is free
  on(Item,Old_base),      %find old base
  Base \= Old_base,
  %then
  retract(on(Item,Old_base)),
  assert(on(Item,Base)).

move_box(Item,Base):-
  %if
  box(Item),
  Item \= Base,
  free(Item),             %Item is free
  free(Base),             %Base is free
  on(Item,Old_base),      %find old base
  Base \= Old_base,
  %then
  retract(on(Item,Old_base)),
  assert(on(Item,Base)).

move(Sa,St):-
  retractall(on(_,_)),
  retractall(free(_)),
  list_to_kb(Sa),
  move_box(a,b),
  kb_to_list(St).
move(Sa,St):-
  retractall(on(_,_)),
  retractall(free(_)),
  list_to_kb(Sa),
  move_box(a,c),
  kb_to_list(St).
move(Sa,St):-
  retractall(on(_,_)),
  retractall(free(_)),
  list_to_kb(Sa),
  move_box(a,t),
  kb_to_list(St).
move(Sa,St):-
  retractall(on(_,_)),
  retractall(free(_)),
  list_to_kb(Sa),
  move_box(b,a),
  kb_to_list(St).
move(Sa,St):-
  retractall(on(_,_)),
  retractall(free(_)),
  list_to_kb(Sa),
  move_box(b,c),
  kb_to_list(St).
move(Sa,St):-
  retractall(on(_,_)),
  retractall(free(_)),
  list_to_kb(Sa),
  move_box(b,t),
  kb_to_list(St).
move(Sa,St):-
  retractall(on(_,_)),
  retractall(free(_)),
  list_to_kb(Sa),
  move_box(c,a),
  kb_to_list(St).
move(Sa,St):-
  retractall(on(_,_)),
  retractall(free(_)),
  list_to_kb(Sa),
  move_box(c,b),
  kb_to_list(St).
move(Sa,St):-
  retractall(on(_,_)),
  retractall(free(_)),
  list_to_kb(Sa),
  move_box(c,t),
  kb_to_list(St).
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
enqueue(X,[],[X]).
enqueue(X,[H|T1],[H|T2]):-enqueue(X,T1,T2).
dequeue(X,[X|T],T).
empty_queue([]).
member_queue(X,Q):-member(X,Q).


pushElementsToQueue([],Queue,Queue).
pushElementsToQueue([Elem|RestElements],Queue,FinalQueue):-
  enqueue(Elem,Queue,NewQueue),
  pushElementsToQueue(RestElements,NewQueue,FinalQueue).

empty_set([]).
member_set(X,[H|_]):- X=H.
member_set(X,[H|T]):- X\=H,member_set(X,T).


union([],S2,S2).
union([H1|_],S2,[H1|T3]):-
  \+member_set(H1,S2), union(_,S2,T3).
union([H1|T1],S2,S3):-
  member_set(H1,S2), union(T1,S2,S3).

unsafe(s100).

reverse([],[]).
reverse([St|Oura],Alista):-
  reverse(Oura,L),
  append(L,[St],Alista).

print_path([State,nil],_):-
  write(State).
print_path([State,Parent],ClosedList_set):-
  member_set([Parent,Grandparent],ClosedList_set),
  print_path([Parent,Grandparent],ClosedList_set),
  write('-->'),write(State).


get_children(State,Rest_OpenList_queue,ClosedList_set,Children):-
  bagof(Child,moves(State,Rest_OpenList_queue,ClosedList_set,Child),Children).
get_children(State,Rest_OpenList_queue,Closed_set,[]).

moves(State,Rest_OpenList_queue,ClosedList_set,[Next,State]):-
  move(State,Next),
  \+(unsafe(Next)),
  \+(member_queue([Next,NodeX],Rest_OpenList_queue)),
  \+(member_set([Next,NodeY],ClosedList_set)).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BFS algorithm, based on DFS presented on the Lab notes
% Run with bfs([on(a,b),on(...), on(..)], [on(..),on(..),on(..)] ).
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
bfs(Start,Goal) :-
  assert(goal(Goal)),
  empty_queue(Empty_openList_queue),
  enqueue([Start,nil],Empty_openList_queue,OpenList_queue),
  empty_set(ClosedList_set),
  path(OpenList_queue,ClosedList_set,Goal).

path(OpenList_queue,_,_):-
  empty_queue(OpenList_queue),
  write('no solution found').

path(OpenList_queue,ClosedList_set,Goal):-
    dequeue([State,Parent],OpenList_queue,Tmp_queue),
    goal(State), State=Goal,
    write('Path of the solution: '),nl,
    print_path([State,Parent],ClosedList_set).

path(OpenList_queue,ClosedList_set,Goal):-
  dequeue([State,Parent],OpenList_queue,Rest_OpenList_queue),
  get_children(State,Rest_OpenList_queue,ClosedList_set,Children),
  reverse(Children,RevChildren),
  pushElementsToQueue(RevChildren,Rest_OpenList_queue,New_OpenList_queue),
  union([[State,Parent]],ClosedList_set,New_closedList_set),
  path(New_OpenList_queue,New_closedList_set,Goal).
