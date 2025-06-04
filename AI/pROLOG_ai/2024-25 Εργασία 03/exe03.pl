% Anna Zoi - th20179 - 12o ejamino - HMMY
% dedomena tis askisis
h(a,85).
h(b,80).
h(c,80).
h(d,85).
h(e,35).
h(f,0).
h(g,50).
h(h,20).
h(i,60).
h(j,85).
h(k,40).
h(l,70).
h(m,80).
h(n,20).
h(o,35).
h(p,60).
h(q,70).
h(r,60).
h(s,50).
h(t,35).
h(u,55).

path(a,d,20). path(a,r,55).
path(b,l,10). path(b,p,20). path(b,s,50).
path(c,i,80). path(c,j,15). path(c,q,30).
path(d,r,40). path(d,g,45).
path(e,i,30). path(e,n,30). path(e,o,30).
path(f,g,55). path(f,h,40). path(f,k,45). path(f,n,25). path(f,o,35). path(f,t,35).
path(g,t,20).
path(h,s,45). path(h,t,20). path(h,u,40).
path(i,p,15).
path(j,m,20).
path(k,m,40). path(k,o,5). path(k,r,75). path(k,q,30).
path(l,t,40).
path(m,q,85).
path(n,s,30).
path(p,s,10).

% dilosi amfidromis diadromis
edge(X,Y,Z) :- path(X,Y,Z).
edge(X,Y,Z) :- path(Y,X,Z).

% greedy best first search
gbfs(X,G,P) :-
    h(X,H), gbfs_search([node(X,[X],H)],G,P_rev), reverse(P_rev,P).

gbfs_search([node(G,P,_H)|_],G,P).
gbfs_search([node(X,P,_)|T],G,P1) :-
    findall(node(X1,[X1|P],H),
        (edge(X,X1,_), \+member(X1, P), h(X1,H)),
        Children),
    append(T,Children,Queue),
    gbfs_sorted(Queue,Sorted),
    gbfs_search(Sorted,G,P1).

% Sort by heuristic (H), then alphabetically by node name
gbfs_sorted(Nodes, Sorted) :-
    map_list_to_pairs(node_h, Nodes, Pairs),
    keysort(Pairs, SortedPairs),
    pairs_values(SortedPairs, Sorted).

node_h(node(Name,_,H), (H, Name)).

% A* search algorithm
a_algor(X,G,P,C) :-
    h(X,H), a_search([node(X,[X],H,0)],G,P_rev,C), reverse(P_rev, P).

a_search([node(G,P,_H,C)|_],G,P,C).
a_search([node(X,P,H,G)|T],G1,P1,C_all) :-
    findall(node(X1,[X1|P],H1,G1New),
        (edge(X,X1,C1), \+member(X1,P), h(X1,H1), G1New is G + C1),
        Children),
    append(T, Children, Queue),
    a_sorted(Queue, Sorted),
    a_search(Sorted,G1,P1,C_all).

% Sort by total cost (G+H), then alphabetically by node name
a_sorted(Nodes, Sorted) :-
    map_list_to_pairs(node_cost, Nodes, Pairs),
    keysort(Pairs, SortedPairs),
    pairs_values(SortedPairs, Sorted).

node_cost(node(Name,_,H,G), (G+H, Name)).

% Example Queries:
% ?- gbfs(a, f, Path).
% Path = [a, r, k, f] .

% ?- a_algor(a, f, Path, Cost).
% Path = [a, d, g, f],
% Cost = 120 .
