import heapq

graph = {
    'A': {'D': 20, 'R': 55},
    'B': {'S': 50, 'P': 20},
    'C': {'J': 15, 'I': 80},
    'D': {'A': 20, 'R': 40, 'G': 45},
    'E': {'I': 30, 'O': 30, 'N': 25},
    'F': {'K': 45, 'G': 55, 'T': 35, 'H': 40, 'O': 35, 'N': 25},
    'G': {'D': 45, 'F': 55, 'T': 20},
    'H': {'F': 40, 'T': 20, 'S': 45, 'U': 40},
    'I': {'C': 80, 'E': 30, 'P': 15},
    'J': {'C': 15, 'M': 20},
    'K': {'R': 75, 'M': 40, 'Q': 30, 'F': 45, 'O': 5},
    'L': {'T': 40, 'U': 10},
    'M': {'J': 20, 'K': 40, 'Q': 85},
    'N': {'F': 25, 'E': 25, 'S': 30},
    'O': {'K': 5, 'F': 35, 'E': 30},
    'P': {'I': 15, 'S': 10, 'B': 20},
    'Q': {'M': 85, 'K': 30, 'C': 30},
    'R': {'A': 55, 'D': 40, 'K': 75},
    'S': {'H': 45, 'N': 30, 'P': 10, 'B': 50},
    'T': {'G': 20, 'F': 35, 'H': 20, 'L': 40},
    'U': {'H': 40, 'L': 10}
}


heuristics = {
    'A': 85, 'B': 80, 'C': 80, 'D': 85, 'E': 35, 'F': 0, 'G': 50, 'H': 20,
    'I': 60, 'J': 85, 'K': 40, 'L': 70, 'M': 80, 'N': 20, 'O': 35, 'P': 60,
    'Q': 70, 'R': 60, 'S': 50, 'T': 35, 'U': 55
}


def greedy_best_first_search(start, goal):
    visited = set()
    queue = [(heuristics[start], start, [start])]
    
    while queue:
        _, current, path = heapq.heappop(queue) # Pop the smallest item off the heap
        if current == goal:
            return path
        
        if current in visited:
            continue
        visited.add(current)

        for neighbor in sorted(graph[current].keys()):
            if neighbor not in visited:
                heapq.heappush(queue, (heuristics[neighbor], neighbor, path + [neighbor]))
    return None

def a_star_search(start, goal):
    open_set = [(heuristics[start], 0, start, [start])]
    visited = {}

    while open_set:
        f, g, current, path = heapq.heappop(open_set)
        
        if current == goal:
            return path
        
        if current in visited and visited[current] <= g:
            continue
        visited[current] = g

        for neighbor in sorted(graph[current].keys()):
            new_g = g + graph[current][neighbor]
            new_f = new_g + heuristics[neighbor]
            heapq.heappush(open_set, (new_f, new_g, neighbor, path + [neighbor]))
    return None


for start in ['A', 'B', 'C']:
    greedy_path = greedy_best_first_search(start, 'F')
    a_star_path = a_star_search(start, 'F')
    print(f"\nΑπό {start} προς F:")
    print(f"  Greedy Best First Path: {' -> '.join(greedy_path)}")
    print(f"  A* Path: {' -> '.join(a_star_path)}")
