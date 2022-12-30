extends Control

onready var ms = load("res://src/main/Main.tscn")

onready var title = $Panel/MarginContainer/VBoxContainer/HBoxContainer/Title
onready var scene_cont = $Panel/MarginContainer/VBoxContainer/Panel/SceneCont

var sname: String
var spath: String

func _ready():
	sname = Gamestate.sname
	spath = Gamestate.spath
	title.text = sname
	
	var sinstance = load(spath).instance()
	
	scene_cont.add_child(sinstance)

func _on_CloseBTN_pressed():
	get_tree().change_scene_to(ms)
