extends Control

# Editor

class PlacedTile:
	var id: int
	var x: int = 0
	var y: int = 0
	var node: MeshInstance2D
	
	func _init(x, y, scale, texture):
		pass

var tile_size = 16.0
var scale = 1.0

var placed_tiles_array = []

var iter_tiles: bool = false

# Settings

onready var file_dialog = $FileDialog
onready var tile_selector_cont = $HSplitContainer/Settings/MarginContainer/VBoxContainer/ScrollContainer/TSContainer
onready var brush_tr = $HSplitContainer/Settings/MarginContainer/VBoxContainer/HBoxContainer2/Brush

var file_path = null
var is_pixel_art: bool = true
# ^ normally would be false

var texture_file: ImageTexture = null 
# ^ used to be of type StreamTexture
var texture_atlas: AtlasTexture = null 

var hframes: int = 1
var vframes: int = 1
var cell_size: Vector2

var brush: int = 0

# Main

func _ready():
#	set_process(false)
	pass

func _process(delta):
	if (iter_tiles):
		pass

# Settings

func fill_tile_selector():
	for child in tile_selector_cont.get_children():
		tile_selector_cont.remove_child(child)
		child.queue_free()
	
	for i in range(0, int(hframes * vframes)):
		var t: Texture = get_texture_in_atlas(i)
		var t_btn: TextureButton = TextureButton.new()
		t_btn.expand = true
		t_btn.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
		t_btn.rect_min_size = Vector2(64, 64)
		t_btn.texture_normal = t
		tile_selector_cont.add_child(t_btn)
		t_btn.connect("pressed", self, "_st_pressed", [i])

# Local Utils

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

# Signals

func _on_STBTN_pressed():
	file_dialog.popup_centered()
	file_dialog.popup()

func _on_FileDialog_file_selected(path):
	print(path)
	file_path = path
	
	var file = File.new()
	file.open(path, File.READ)
	var bytes = file.get_buffer(file.get_len())
	file.close()
	
	var img = Image.new()
	img.load_png_from_buffer(bytes)
	var t = ImageTexture.new()
	t.create_from_image(img, 1)
	
	texture_file = t
	texture_atlas = AtlasTexture.new()
	texture_atlas.atlas = texture_file
	cell_size.x = texture_atlas.get_size().x / vframes
	cell_size.y = texture_atlas.get_size().y / hframes
	fill_tile_selector()

func _on_HSpinBox_value_changed(value):
	hframes = value
	if (texture_atlas != null):
		cell_size.y = texture_atlas.get_size().y / hframes
		fill_tile_selector()

func _on_VSpinBox_value_changed(value):
	vframes = value
	if (texture_atlas != null):
		cell_size.x = texture_atlas.get_size().x / vframes
		fill_tile_selector()

func _st_pressed(id: int):
	brush = id
	brush_tr.texture = get_texture_in_atlas(id)

#func _on_IsPixelArt_toggled(button_pressed):
#	is_pixel_art = button_pressed
#	if (file_path != null):
#		_on_FileDialog_file_selected(file_path)
