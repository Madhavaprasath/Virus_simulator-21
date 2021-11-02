extends Control

onready var task_manager=get_node("TextureRect/Startmenu")
onready var tutorial=get_node("TextureRect/Tutorial")
onready var trash=get_node("TextureRect/Trash")
onready var hill=get_node("TextureRect/HillCollision")
onready var virus=get_node("TextureRect/Virus")

var allow_new_window := true # To avoid 2 simultaneous windows
var has_virus_spawned := false

func _ready():
	toggle_virus()
	for button in get_tree().get_nodes_in_group("Icons"):
		button.connect("pressed",self,"on_icons_pressed",[button.get_groups(),button.name])

func toggle_virus():
	virus.set_physics_process(not virus.is_physics_processing())
	virus.visible = not virus.visible
	
func toggle_collisions(body, state=null):
	if not body:
		return
	# Every child should be a CollisionShape
	# Default: Switches value
	for c in body.get_children():
		if state != null:
			c.disabled = not state
		else:
			c.disabled = not c.disabled
		print(body.get_parent().name)
		print(c.disabled)

func on_icons_pressed(group,b_name):
	match group[1]:
		"File":
			var scene=open_scene(b_name)
			get_tree().change_scene(scene)
		"Internet":
			OS.shell_open("https://www.youtube.com/watch?v=dQw4w9WgXcQ")
		"Start":
			task_manager.visible = not task_manager.visible
		"Shutdown":
			get_tree().quit()
		"Restart":
			get_tree().reload_current_scene()
		"Tutorial":
			if allow_new_window:
				tutorial.visible=true
				allow_new_window=false
				toggle_collisions(tutorial.get_node("StaticBody2D"))
				toggle_collisions(hill, false)
				if not has_virus_spawned:
					toggle_virus()
					has_virus_spawned = true
		"Trash":
			if allow_new_window:
				trash.visible=true
				allow_new_window=false
				toggle_collisions(trash.get_node("StaticBody2D"))
				toggle_collisions(hill, false)
		"Close":
			var window="TextureRect/"+str(b_name)
			get_node(window).visible = false
			allow_new_window = true
			print("TOGGLE COLLISION")
			toggle_collisions(
				get_node(window).get_node("StaticBody2D"),
				false
			)
			toggle_collisions(hill, true)

func open_scene(area_name):
	return ("res://Platformer/Scenes/"+str(area_name)+"/"+str(area_name)+"-level1.tscn")
