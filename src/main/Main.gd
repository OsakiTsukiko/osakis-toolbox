extends Control

onready var btn_cont = $Panel/MarginContainer/Main/CenterContainer/VBoxContainer/PanelContainer/ScrollContainer/BtnCont

const msl = preload("res://src/main/MainSceneLoader.tscn")

class SceneObj:
	var path: String
	var name: String
	
	func _init(path: String, name: String):
		self.path = path
		self.name = name

var scene_list = [
	SceneObj.new( 
		"res://src/wfc/tile_editor/TileEditor.tscn", 
		"Tile Editor" 
	)
]

func _ready():
	for sc in scene_list:
		var btn = Button.new()
		btn.text = sc.name
		btn.align = Button.ALIGN_LEFT
		btn.connect("pressed", self, "_scene_btn", [sc.path, sc.name])
		btn_cont.add_child(btn)

func _scene_btn(path: String, name: String):
	Gamestate.sname = name
	Gamestate.spath = path
	get_tree().change_scene_to(msl)
