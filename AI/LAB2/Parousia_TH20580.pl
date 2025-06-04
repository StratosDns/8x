% Ορισμός των κατηγορημάτων για τη στοίβα
empty_stack(stack([])).

push(stack(L), X, stack([X|L])).

top(stack([X|_]), X).

pop(stack([_|L]), stack(L)).

% Κύριο κατηγόρημα για εισαγωγή ονομάτων
read_names(FinalStack) :-
    empty_stack(InitStack),
    read_names_helper(InitStack, FinalStack).

read_names_helper(Stack, Stack) :-
    top(Stack, TopName),
    (TopName == 'telos'), !.

read_names_helper(CurrentStack, FinalStack) :-
    write('Give a name: '),
    read(Name),
    (
        (Name == 'telos') 
        -> FinalStack = CurrentStack
        ; (
            push(CurrentStack, Name, NewStack),
            read_names_helper(NewStack, FinalStack)
        )
    ).

% Κατηγόρημα εκτύπωσης στοίβας
print_stack(stack([])).
print_stack(Stack) :-
    \+ empty_stack(Stack),
    top(Stack, TopName),
    write(TopName), nl,
    pop(Stack, NewStack),
    print_stack(NewStack).

% Κύριο πρόγραμμα
main :-
    read_names(Stack),
    print_stack(Stack).