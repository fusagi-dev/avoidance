extends TextureButton


@export var texture_floodable: CompressedTexture2D = preload("res://assets/images/Levels/bright.png")

var texture_default: CompressedTexture2D
var color: int
var region_id = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	texture_default = texture_normal
	color = texture_default.get_rid().get_id()
	get_tree().call_group("level", "register_tile", position, get_instance_id(), color)
	#print("Instantiated tile at coords " + str(position) + " with texture " + str(texture_default.get_rid()))

func _on_mouse_entered():
	#print("mouse in region " + str(region_id))
	get_tree().call_group("level", "highlight_region", region_id)

func highlight(highlighted_region_id: int):
	#print("my region: " + str(region_id))
	if highlighted_region_id == region_id:
		texture_normal = texture_floodable

func unhighlight(highlighted_region_id: int):
	if highlighted_region_id == region_id:
		texture_normal = texture_default


func _on_pressed():
	get_tree().call_group("level", "fill_region", region_id)
