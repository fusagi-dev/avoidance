@tool
extends EditorScript

# Called when the script is executed (using File -> Run in Script Editor).
func _run():
	var input_texture: Texture2D = preload("res://assets/images/Levels/castle.png")
	var input_image: Image = input_texture.get_image()
	
	var palette = {}
	var atlas = TileSetAtlasSource.new()
	atlas.texture = input_texture
	atlas.texture_region_size = Vector2i(1,1)
	
	for x in range(input_image.get_width()):
		for y in range(input_image.get_height()):
			var pixel = input_image.get_pixel(x, y)
			if pixel not in palette:
				print("new color: " + str(pixel))
				palette[pixel] = Vector2i(x, y)
				atlas.create_tile(Vector2i(x, y))

	print(palette)

	var tile_set = TileSet.new()
	tile_set.add_source(atlas)
	
	var tilemap = TileMap.new()
	tilemap.tile_set = tile_set
	tilemap.add_layer(0)
	
	for x in range(input_image.get_width()):
		for y in range(input_image.get_height()):
			var pixel = input_image.get_pixel(x, y)
			tilemap.set_cell(0, Vector2i(x, y), 0, palette[pixel])
	
	var scene = PackedScene.new()
	var result = scene.pack(tilemap)
	if result == OK:
		var error = ResourceSaver.save(scene, "res://scenes/GameScene/Levels/LevelTileMap.tscn")
		if error != OK:
			push_error("Something went wrong when saving the scene to disk.")
