extends TextureButton


@export var texture_floodable: CompressedTexture2D = preload("res://assets/images/Levels/bright.png")

var texture_default: CompressedTexture2D
var region_id = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	texture_default = texture_normal
	get_instance_id()
	get_tree().call_group("level", "register_tile", position, get_instance_id(), texture_default.get_rid())
	#print("Instantiated tile at coords " + str(position) + " with texture " + str(texture_default.get_rid()))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



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
