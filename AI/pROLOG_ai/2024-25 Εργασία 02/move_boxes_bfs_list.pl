box(a).
box(b).
box(c).
table_(t).

%A quick and dirty way to check if two 3-element sets have the same elements.
%set_intersection(S1,S2,S1) did not work !
same([X,Y,Z],[A,B,C]):-
  member(X,[A,B,C]),
  member(Y,[A,B,C]),
  member(Z,[A,B,C]),
  member(A,[X,Y,Z]),
  member(B,[X,Y,Z]),
  member(C,[X,Y,Z]).

%moves box from table to another box
%Item is the box to be moved,  Sa is the initial state and St is the final state
move_box(Item,Base,Sa,St):-
  %if
  table_(Base),   % if base is table
  \+table_(Item),
  \+member(on(_,Item),Sa),       % Item is free
  member(on(Item,Old_base),Sa),  % find old base
  Base \= Old_base,
  %then
  delete(Sa,on(Item,Old_base),T1), % we used delete predicate provided by SWI prolog
  append(T1,[on(Item,Base)],T2),   % ditto for append
  same(T2,St).   % check if resulting list matches final

%moves box from a box to another box
move_box(Item,Base,Sa,St):-
  %if
  box(Item),  % base is a box
  Item \= Base, % we cannot put an item on itself!
  \+member(on(_,Item),Sa),        %Item is free
  \+member(on(_,Base),Sa),        %Base is free
  member(on(Item,Old_base),Sa),   %find old base
  Base \= Old_base,
  %then
  delete(Sa,on(Item,Old_base),T1), % move item
  append(T1,[on(Item,Base)],T2),
  same(T2,St).

move(Sa,St):-move_box(a,b,Sa,St). % rules for every possible move
move(Sa,St):-move_box(a,c,Sa,St).
move(Sa,St):-move_box(a,t,Sa,St).
move(Sa,St):-move_box(b,c,Sa,St).
move(Sa,St):-move_box(b,a,Sa,St).
move(Sa,St):-move_box(b,t,Sa,St).
move(Sa,St):-move_box(c,b,Sa,St).
move(Sa,St):-move_box(c,a,Sa,St).
move(Sa,St):-move_box(c,t,Sa,St).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BFS algorithm, based on DFS presented on the Lab notes
% Run with bfs([on(a,b),on(...), on(..)], [on(..),on(..),on(..)] ).
%
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


bfs(Start,Goal) :-
  assert(goal(Goal)),                       % Add a fact with the new goal
  empty_queue(Empty_openList_queue),
  enqueue([Start,nil],Empty_openList_queue,OpenList_queue),
  empty_set(ClosedList_set),
  path(OpenList_queue,ClosedList_set,Goal).

path(OpenList_queue,_,_):-
  empty_queue(OpenList_queue),
  write('no solution found').

path(OpenList_queue,ClosedList_set,Goal):-
    dequeue([State,Parent],OpenList_queue,Tmp_queue),
    goal(State),
    same(Goal,State),                       % Check for similarity as the order of the elements may be different
    write('Path of the solution: '),nl,
    print_path([State,Parent],ClosedList_set).

path(OpenList_queue,ClosedList_set,Goal):-
  dequeue([State,Parent],OpenList_queue,Rest_OpenList_queue),
  get_children(State,Rest_OpenList_queue,ClosedList_set,Children),
  reverse(Children,RevChildren),
  pushElementsToQueue(RevChildren,Rest_OpenList_queue,New_OpenList_queue),
  union([[State,Parent]],ClosedList_set,New_closedList_set),
  path(New_OpenList_queue,New_closedList_set,Goal).
