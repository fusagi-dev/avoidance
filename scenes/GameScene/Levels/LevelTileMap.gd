extends TileMap

signal level_ready

var cell_to_id = {}
var id_to_cell = {}
var neighbors = []
var neighbor_regions = []
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

func register_tile(global_position: Vector2i, instance_id: int, color: RID):
	#var map_position = local_to_map(to_local(global_position))
	var map_position = local_to_map(global_position)
	cell_to_id[map_position] = [instance_id, color]
	id_to_cell[instance_id] = map_position
	instance_from_id(instance_id).add_to_group("tiles")
	#print("Registered tile of color " + str(color) + " at position " + str(map_position))
	if len(cell_to_id) == 64 * 64:
		emit_signal("level_ready")

func get_cell(coords: Vector2i):
	return instance_from_id(cell_to_id[coords][0])

func init_cell_groups():
	void_cells = get_used_cells(1)
	for void_cell_coords in void_cells:
		var new_neighbors = get_neighbors(void_cell_coords)
		for neighbor_coords in new_neighbors:
			if neighbor_coords not in neighbors:
				if neighbor_coords not in void_cells:
					if neighbor_coords in cell_to_id.keys():
						neighbors.append(neighbor_coords)
						get_cell(neighbor_coords).add_to_group("neighbors")

	print(neighbors)

	#get_tree().call_group("neighbors", "_on_mouse_entered")

func propagate_region(coords: Vector2i, region_id: int, color: RID):
	if coords not in cell_to_id or coords in void_cells:
		return
	if coords in neighbor_regions[region_id]:
		return
	if cell_to_id[coords][1] != color:
		return
	neighbor_regions[region_id].append(coords)
	all_adjacent_tiles.append(coords)
	get_cell(coords).region_id = region_id
	for neighbor in get_neighbors(coords):
		propagate_region(neighbor, region_id, color)

func calculate_neighbor_regions():
	# make tiles remove themselves from group when needed
	neighbor_regions = []
	all_adjacent_tiles = []
	for neighbor in neighbors:
		if neighbor in all_adjacent_tiles:
			continue
		var region_id = len(neighbor_regions)
		neighbor_regions.append([])
		propagate_region(neighbor, region_id, cell_to_id[neighbor][1])
	

# Called when the node enters the scene tree for the first time.
func _ready():
	await level_ready
	init_cell_groups()
	calculate_neighbor_regions()
	print(len(neighbor_regions))
	print(len(neighbor_regions[0]))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

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

# doesn't work currently
func _on_texture_rect_mouse_exited():
	print("removing highlight")
	get_tree().call_group("tiles", "unhighlight", highlighted_region)
	highlighted_region = -2
