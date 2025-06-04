from collections import deque
import copy

# Ελέγχει αν ένα αντικείμενο έχει κάτι πάνω του
def has_on_top(state, x):
    return any(v == x for v in state.values())

# Παράγει όλες τις επόμενες έγκυρες καταστάσεις από την τρέχουσα
def successors(state):
    result = []
    blocks = ['a', 'b', 'c']
    support = ['a', 'b', 'c', 't']  # Πάνω σε ποιο αντικείμενο μπορεί να μπει ένα μπλοκ

    for x in blocks:
        if has_on_top(state, x):
            continue  # Αν το X έχει κάτι πάνω του, δεν μπορούμε να το μετακινήσουμε

        for y in support:
            if x == y:
                continue  # Δεν επιτρέπεται να βάλουμε ένα μπλοκ πάνω στον εαυτό του
            if y != 't' and has_on_top(state, y):
                continue  # Αν το Y είναι άλλο μπλοκ και έχει κάτι πάνω του, δεν επιτρέπεται

            new_state = copy.deepcopy(state)
            new_state[x] = y  # Μετακινούμε το X πάνω στο Y

            if new_state != state:
                result.append((f"move({x},{y})", new_state))  # Προσθέτουμε νέο βήμα και κατάσταση

    return result


# Ελέγχει αν η κατάσταση είναι η τελική
def is_goal(state):
    return state == {'a': 'b', 'b': 'c', 'c': 't'}

# Εκτυπώνει την κατάσταση
def print_state(state):
    print("Κατάσταση:")
    for block in sorted(state.keys()):
        print(f"  {block} πάνω σε {state[block]}")
    print()


# BFS αναζήτηση
def bfs(start):
    visited = set()
    queue = deque([(start, [])])  # (τρέχουσα κατάσταση, λίστα κινήσεων)

    while queue:
        state, path = queue.popleft()
        state_tuple = tuple(sorted(state.items()))
        if state_tuple in visited:
            continue
        visited.add(state_tuple)

        if is_goal(state):
            print("\n--- Τελική κατάσταση επιτεύχθηκε (BFS) ---\n")
            print_state(state)
            return path # Επιστροφή των βημάτων που οδηγήσαν στην τελική κατάσταση

        print("Εξετάζουμε νέα κατάσταση:")
        print_state(state)

        for action, new_state in successors(state):
            print(f"Εκτελώ: {action}")
            print_state(new_state)
            queue.append((new_state, path + [action]))

    return None # Δεν βρέθηκε λύση


# DFS αναζήτηση
def dfs(start):
    visited = set()
    stack = [(start, [])]  # (τρέχουσα κατάσταση, λίστα κινήσεων)

    while stack:
        state, path = stack.pop()
        state_tuple = tuple(sorted(state.items()))
        if state_tuple in visited:
            continue
        visited.add(state_tuple)

        if is_goal(state):
            print("\n--- Τελική κατάσταση επιτεύχθηκε (DFS) ---\n")
            print_state(state)
            return path # Επιστροφή των βημάτων που οδηγήσαν στην τελική κατάσταση

        print("Εξετάζουμε νέα κατάσταση:")
        print_state(state)

        for action, new_state in successors(state):
            print(f"Εκτελώ: {action}")
            print_state(new_state)
            stack.append((new_state, path + [action]))

    return None # Δεν βρέθηκε λύση


# Αρχική κατάσταση
initial_state = {'a': 'c', 'b': 't', 'c': 't'}

# Εκτέλεση BFS και DFS
print("BFS Solution:")
print(bfs(initial_state))

print("\nDFS Solution:")
print(dfs(initial_state))
