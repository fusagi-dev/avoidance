extends TextureButton


@export var texture_floodable: CompressedTexture2D = preload("res://assets/images/Levels/purple.png")

var texture_default: CompressedTexture2D

# Called when the node enters the scene tree for the first time.
func _ready():
	texture_default = texture_normal

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_mouse_entered():
	texture_normal = texture_floodable

func _on_mouse_exited():
	texture_normal = texture_default
