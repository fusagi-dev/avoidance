extends TileMap

signal level_ready
signal void_prevailed

var cell_to_id = {}
var id_to_cell = {}
var neighbors = []
var neighbor_regions = {}
var all_adjacent_tiles = []
var void_cells = []
var highlighted_region: int = -2

func get_neighbors(coords: Vector2i):
	return [
		get_neighbor_cell(coords, TileSet.CELL_NEIGHBOR_LEFT_SIDE),
		get_neighbor_cell(coords, TileSet.CELL_NEIGHBOR_TOP_SIDE),
		get_neighbor_cell(coords, TileSet.CELL_NEIGHBOR_RIGHT_SIDE),
		get_neighbor_cell(coords, TileSet.CELL_NEIGHBOR_BOTTOM_SIDE)
	]

func register_tile(tile_position: Vector2i, instance_id: int, color: int):
	var map_position = local_to_map(tile_position)
	cell_to_id[map_position] = [instance_id, color]
	id_to_cell[instance_id] = map_position
	instance_from_id(instance_id).add_to_group("tiles")
	#print("Registered tile of color " + str(color) + " at position " + str(map_position))
	if len(cell_to_id) == 64 * 64:
		emit_signal("level_ready")

func get_cell(coords: Vector2i):
	return instance_from_id(cell_to_id[coords][0])

func update_cell_groups(new_void_cells):
	void_cells.append(new_void_cells)
	for void_cell_coords in new_void_cells:
		var new_neighbors = get_neighbors(void_cell_coords)
		for neighbor_coords in new_neighbors:
			if neighbor_coords not in neighbors:
				if neighbor_coords not in void_cells:
					if neighbor_coords in cell_to_id.keys():
						neighbors.append(neighbor_coords)
						get_cell(neighbor_coords).add_to_group("neighbors")

	#print(neighbors)

	#get_tree().call_group("neighbors", "_on_mouse_entered")

func propagate_region(coords: Vector2i, color: int):
	if coords not in cell_to_id or coords in void_cells:
		return
	if coords in neighbor_regions[color]:
		return
	if cell_to_id[coords][1] != color:
		return
	neighbor_regions[color].append(coords)
	all_adjacent_tiles.append(coords)
	#print("propagated to " +  str(coords))
	get_cell(coords).region_id = color
	for neighbor in get_neighbors(coords):
		#print("propagating color " + str(color) + " from " + str(coords) + " to " + str(neighbor))
		propagate_region(neighbor, color)

func calculate_neighbor_regions():
	# make tiles remove themselves from group when needed
	neighbor_regions = {}
	all_adjacent_tiles = []
	for neighbor in neighbors:
		if neighbor in all_adjacent_tiles:
			continue
		var color = cell_to_id[neighbor][1]
		if color not in neighbor_regions:
			neighbor_regions[color] = []
		propagate_region(neighbor, color)
	print(len(neighbor_regions))
	

# Called when the node enters the scene tree for the first time.
func _ready():
	await level_ready
	update_cell_groups(get_used_cells(1))
	calculate_neighbor_regions()

func highlight_region(region_id: int):
	if highlighted_region == region_id:
		return
	print("highlighting region " + str(region_id))
	get_tree().call_group("tiles", "unhighlight", highlighted_region)
	if region_id != -1:
		get_tree().call_group("tiles", "highlight", region_id)
		highlighted_region = region_id
	else:
		highlighted_region = -2

func fill_region(region_id: int):
	if region_id == -1:
		print("weird region id!")
		return
	var region_tiles = neighbor_regions[region_id]
	#print(region_tiles)
	for tile in region_tiles:
		set_cell(1, tile, 2, tile)
		get_cell(tile).region_id = -1
	
	var new_neighbors = []
	for neighbor in neighbors:
		if not neighbor in region_tiles:
			new_neighbors.append(neighbor)
	neighbors = new_neighbors
	update_cell_groups(region_tiles)
	calculate_neighbor_regions()
	
	if len(get_used_cells(1)) == 64 * 64:
		print("void prevailed!")
		emit_signal("void_prevailed")

# doesn't work currently
func _on_texture_rect_mouse_exited():
	print("removing highlight")
	get_tree().call_group("tiles", "unhighlight", highlighted_region)
	highlighted_region = -2
