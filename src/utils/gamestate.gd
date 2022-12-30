extends Node

var sname: String
var spath: String

var texture_atlas: AtlasTexture = null 
var cell_size: Vector2

func get_texture_in_atlas(id: int):
	var size = texture_atlas.get_size() / cell_size
	if (id >= size.x * size.y):
		return null
	var pos := Vector2.ZERO
	pos.y = floor(id / int(size.x))
	pos.x = id % int(size.x)
	var texture = texture_atlas.duplicate()
	texture.region = Rect2(pos.x * cell_size.x, pos.y * cell_size.y, cell_size.x, cell_size.y)
	return texture
