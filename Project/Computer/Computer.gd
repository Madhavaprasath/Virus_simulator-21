extends Control

onready var task_manager=get_node("TextureRect/Startmenu")
onready var tutorial=get_node("TextureRect/Tutorial")
onready var trash=get_node("TextureRect/Trash")

func _ready():
	for button in get_tree().get_nodes_in_group("Icons"):
		button.connect("pressed",self,"on_icons_pressed",[button.get_groups(),button.name])

func on_icons_pressed(group,b_name):
	match group[1]:
		"File":
			var scene=open_scene(b_name)
			get_tree().change_scene(scene)
		"Internet":
			OS.shell_open("https://www.youtube.com/watch?v=dQw4w9WgXcQ")
		"Start":
			task_manager.visible=not task_manager.visible
		"Shutdown":
			get_tree().quit()
		"Restart":
			get_tree().reload_current_scene()
		"Tutorial":
			tutorial.visible=true
		"Trash":
			trash.visible=true
		"Close":
			var window="TextureRect/"+str(b_name)
			get_node(window).visible=false

func open_scene(area_name):
	return ("res://Scenes/"+str(area_name)+"/"+str(area_name)+"-level1.tscn")
