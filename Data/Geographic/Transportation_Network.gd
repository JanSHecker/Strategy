extends Node
class_name TransportationNetwork

var cached_distances = {}
var dirty_regions = {}

var adjacency_matrix = {}

func create_adjacency_matrix():
	print("compute adjacency matrix for %s regions"%[str(GameState.regions.size())])
	var regions = GameState.regions.values()
	for region in regions:
		var adjacencies = {}
		var neighbors = region.get_neighbors()
		for neighbor_id in neighbors:
			var neighbor = GameState.regions.get(neighbor_id)
			if neighbor:
				var region_hub = GameState.provinces.get(region.hub)
				var neighbor_hub = GameState.provinces.get(neighbor.hub)
				adjacencies[neighbor_id]  = hex_distance(
					region_hub.location.x,
					region_hub.location.y,
					neighbor_hub.location.x,
					neighbor_hub.location.y
					)
		adjacency_matrix[region.id] = adjacencies
		print(adjacency_matrix)


func hex_distance(q1: int, r1: int, q2: int, r2: int):
	var dx = abs(q1 - q2)
	var dy = abs(r1 - r2)
	var dz = abs((q1 + r1) - (q2 + r2))
	return (dx + dy + dz) / 2
	
	
	
func compute_all_pairs_shortest_paths():
	print("compute shortest path")
	cached_distances.clear()
	for region_id in GameState.regions:
		cached_distances[region_id] = dijkstra_from(region_id)
	dirty_regions.clear()

		
func dijkstra_from(start_id: String) -> Dictionary:
	# Stores shortest distances from start_id to every other region
	var dist: Dictionary = {}
	var visited: Dictionary = {}
	var pq := PriorityQueue.new()

	# Initialize distances
	for id in GameState.regions.keys():
		dist[id] = INF
	dist[start_id] = 0

	# Push start node into priority queue
	pq.push(0, start_id)

	while not pq.is_empty():
		var current = pq.pop()
		var current_distance: float = current[0]
		var current_id: String = current[1]

		# Skip if we already visited
		if visited.has(current_id):
			continue
		visited[current_id] = true

		# Relax edges
		var neighbors = adjacency_matrix.get(current_id, {})
		for neighbor_id in neighbors.keys():
			var alt = current_distance + neighbors[neighbor_id]
			if alt < dist[neighbor_id]:
				dist[neighbor_id] = alt
				pq.push(alt, neighbor_id)

	return dist

func update_edge(region_a, region_b, new_distance):
	var regions = GameState.regions.values()
	var old_distance = adjacency_matrix.get(str(region_a), {}).get(str(region_b), INF)
	adjacency_matrix[str(region_a)][str(region_b)] = new_distance
	adjacency_matrix[str(region_b)][str(region_a)] = new_distance

	# Check if the new distance is better or worse than the old distance
	if new_distance < old_distance:
		# If the new distance is shorter, update all paths that might benefit
		for i in regions:
			for j in regions:
				if cached_distances[str(i)][str(j)] > cached_distances[str(i)][str(region_a)] + new_distance + cached_distances[str(region_b)][str(j)]:
					cached_distances[str(i)][str(j)] = cached_distances[str(i)][str(region_a)] + new_distance + cached_distances[str(region_b)][str(j)]
	else:
		# If the new distance is longer, mark all paths as dirty
		dirty_regions = {}
		for i in regions:
			dirty_regions[str(i)] = true
			
func get_cached_shortest_path(region_a: Region, region_b: Region):
	var start_key = region_a.id
	var end_key = region_b.id

	# Check if the cached result is dirty or missing
	if dirty_regions.get(start_key, false) or dirty_regions.get(end_key, false) or not cached_distances.get(start_key, {}).has(end_key):
		# Recompute all pairs shortest paths if necessary
		if dirty_regions.size() > 0:
			print("muss rechnen")
			compute_all_pairs_shortest_paths()

	# Return the cached result
	return cached_distances[str(start_key)][str(end_key)]
