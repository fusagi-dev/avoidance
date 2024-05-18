extends TileMap

signal level_ready

var painting_cells = {}
var neighbors = []

func register_tile(global_position: Vector2i, instance_id: int, color: RID):
	#var map_position = local_to_map(to_local(global_position))
	var map_position = local_to_map(global_position)
	painting_cells[map_position] = [instance_id, color]
	#print("Registered tile of color " + str(color) + " at position " + str(map_position))
	if len(painting_cells) == 64 * 64:
		emit_signal("level_ready")

func init_cell_groups():
	var void_cells = get_used_cells(1)
	for void_cell_coords in void_cells:
		var new_neighbors = get_surrounding_cells(void_cell_coords)
		for neighbor_coords in new_neighbors:
			if neighbor_coords not in neighbors:
				if neighbor_coords not in void_cells:
					print(neighbor_coords)
					print(neighbor_coords in painting_cells.keys())
					if neighbor_coords in painting_cells.keys():
						neighbors.append(neighbor_coords)
						instance_from_id(painting_cells[neighbor_coords][0]).add_to_group("neighbors")

	get_tree().call_group("neighbors", "_on_mouse_entered")

# Called when the node enters the scene tree for the first time.
func _ready():
	await level_ready
	init_cell_groups()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
