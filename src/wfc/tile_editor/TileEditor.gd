extends Control

# Editor

class PlacedTile:
	var id: int
	var x: int = 0
	var y: int = 0
	var scale: int = 1
	var node: TextureRect
	
	func _init(x, y, scale, texture_id):
		id = texture_id
		self.x = x
		self.y = y
		self.scale = scale
		node = TextureRect.new()
		node.expand = true
		node.rect_min_size = Vector2(1, 1)
		node.rect_size = Vector2(1, 1)
		node.rect_scale = Vector2(scale, scale)
		node.rect_global_position = Vector2(x, y) * scale
		node.texture = Gamestate.get_texture_in_atlas(texture_id)
	
	func redraw():
		node.texture = Gamestate.get_texture_in_atlas(id)

onready var tile_cont = $HSplitContainer/Tiles

# var tile_size = 1.0
var scale = 32.0

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

var hframes: int = 1
var vframes: int = 1

var brush: int = -1

# Main

func _ready():
#	set_process(false)
	pass

func paint(canvas_pos: Vector2, offset: Vector2):
	if (brush == -1):
		return
	var p = Vector2(floor(canvas_pos.x / scale), floor(canvas_pos.y / scale))
	# add offset
	for pt in placed_tiles_array:
		if (pt.x == p.x && pt.y == p.y):
			pt.id = brush
			pt.redraw()
			return
	var pt = PlacedTile.new(p.x, p.y, scale, brush)
	placed_tiles_array.append(pt)
	tile_cont.add_child(pt.node)

func _process(delta):
	if (iter_tiles):
		pass

# Settings

func fill_tile_selector():
	for child in tile_selector_cont.get_children():
		tile_selector_cont.remove_child(child)
		child.queue_free()
	
	for i in range(0, int(hframes * vframes)):
		var t: Texture = Gamestate.get_texture_in_atlas(i)
		var t_btn: TextureButton = TextureButton.new()
		t_btn.expand = true
		t_btn.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
		t_btn.rect_min_size = Vector2(64, 64)
		t_btn.texture_normal = t
		tile_selector_cont.add_child(t_btn)
		t_btn.connect("pressed", self, "_st_pressed", [i])

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
	Gamestate.texture_atlas = AtlasTexture.new()
	Gamestate.texture_atlas.atlas = texture_file
	Gamestate.cell_size.x = Gamestate.texture_atlas.get_size().x / vframes
	Gamestate.cell_size.y = Gamestate.texture_atlas.get_size().y / hframes
	fill_tile_selector()

func _on_HSpinBox_value_changed(value):
	hframes = value
	if (Gamestate.texture_atlas != null):
		Gamestate.cell_size.y = Gamestate.texture_atlas.get_size().y / hframes
		fill_tile_selector()

func _on_VSpinBox_value_changed(value):
	vframes = value
	if (Gamestate.texture_atlas != null):
		Gamestate.cell_size.x = Gamestate.texture_atlas.get_size().x / vframes
		fill_tile_selector()

func _st_pressed(id: int):
	brush = id
	brush_tr.texture = Gamestate.get_texture_in_atlas(id)

#func _on_IsPixelArt_toggled(button_pressed):
#	is_pixel_art = button_pressed
#	if (file_path != null):
#		_on_FileDialog_file_selected(file_path)
