:- use_module(library(readutil)). % Χρήση της βιβλιοθήκης για ανάγνωση string

% Ορισμός άδειας ουράς
empty_queue([]).

% Εισαγωγή στοιχείου στο τέλος της ουράς
enqueue(X, Q, NewQ) :- append(Q, [X], NewQ).

% Ανάγνωση εισόδου από τον χρήστη και αποθήκευση στην ουρά
read_names(Q, FinalQ) :-
    write('Give Name: '),
    flush_output, % Εξασφαλίζει σωστή εκτύπωση πριν τη λήψη εισόδου
    read_line_to_string(user_input, Name), % Διαβάζει είσοδο ως string
    ( Name == "telos" -> FinalQ = Q  % Τερματισμός μόνο αν δοθεί "telos"
    ; enqueue(Name, Q, NewQ), read_names(NewQ, FinalQ) ).

% Εκτύπωση των στοιχείων της ουράς
print_queue([]).
print_queue([H|T]) :-
    write(H), nl,
    print_queue(T).

% Εκτέλεση του προγράμματος
start :-
    empty_queue(Q),
    read_names(Q, FinalQ),
    write('Updated Queue:'), nl,
    print_queue(FinalQ).
