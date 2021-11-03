extends Control

onready var task_manager=get_node("TextureRect/Startmenu")
onready var tutorial=get_node("TextureRect/Tutorial")
onready var trash=get_node("TextureRect/Trash")
onready var hill=get_node("TextureRect/HillCollision")
onready var virus=get_node("TextureRect/Virus")


var allow_new_window := true # To avoid 2 simultaneous windows
var has_virus_spawned := false
var current_status="Uninfected"



var Pc_stats=Global.pc_stats
var locked=Global.locked_status

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

func on_icons_pressed(group,b_name):
	
	match group[1]:
		"File":
			if locked[b_name] in ["Unlocked"]:
				var scene=open_scene(b_name)
				get_tree().change_scene(scene)
		"Start":
			task_manager.visible = not task_manager.visible
		"Shutdown":
			get_tree().quit()
		"Restart":
			get_tree().reload_current_scene()
		"Close":
			var window="TextureRect/"+str(b_name)
			get_node(window).visible = false
			allow_new_window = true
			toggle_collisions(
				get_node(window).get_node("StaticBody2D"),
				false
			)
			toggle_cloud_collision(false)
			toggle_collisions(hill, true)
	match group[2]:
		"Tutorial":
			if allow_new_window:
				tutorial.visible=true
				allow_new_window=false
				toggle_collisions(tutorial.get_node("StaticBody2D"))
				toggle_collisions(hill, false)
				toggle_cloud_collision(true)
				if not has_virus_spawned:
					toggle_virus()
					has_virus_spawned = true
		"Internet":
			OS.shell_open("https://www.youtube.com/watch?v=dQw4w9WgXcQ")
		"Trash":
			if allow_new_window:
				trash.visible=true
				allow_new_window=false
				toggle_collisions(trash.get_node("StaticBody2D"))
				toggle_collisions(hill, false)
				toggle_cloud_collision(true)
func open_scene(area_name):
	return ("res://Platformer/Scenes/"+str(area_name)+"/"+str(area_name)+"-level1.tscn")

func toggle_cloud_collision(toggle):
	for cloud in get_tree().get_nodes_in_group("Clouds"):
		var poly=cloud.get_node("CollisionPolygon2D")
		poly.disabled=toggle




func change_icon(status):
	for i in get_tree().get_nodes_in_group("Infectable"):
		var current_group=i.get_groups()
		var elements=""
		for element in current_group:
			if element in ["File","Trash","Tutorial","BackGround","Internet"]:
				elements=element
		if elements!="File":
			if i is TextureRect:
				i.texture=load(Pc_stats[elements][status])
			else:
				i.texture_normal=load(Pc_stats[elements][status])
		else:
			i.texture_normal=load(Pc_stats[elements][status][locked[i.name]])
		yield(get_tree().create_timer(0.2),"timeout")
		
