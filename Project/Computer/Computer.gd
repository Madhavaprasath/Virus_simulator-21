extends Control

onready var task_manager=get_node("TextureRect/Startmenu")
onready var tutorial=get_node("TextureRect/Tutorial")
onready var trash=get_node("TextureRect/Trash")
onready var hill=get_node("TextureRect/HillCollision")
onready var virus=get_node("TextureRect/Virus")
onready var GlitchShader = preload("res://Computer/glitch_effect.shader").duplicate(true)

var allow_new_window := true # To avoid 2 simultaneous windows
var has_virus_spawned := false
var current_status="Uninfected"

var Pc_stats=Global.pc_stats
var locked=Global.locked_status

func _ready():
	toggle_virus()
	for button in get_tree().get_nodes_in_group("Icons"):
		button.connect("pressed",self,"on_icons_pressed",[button.get_groups(),button.name])
	toggle_all_icons("Uninfected")

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

func get_group_element(group):
	var possible_groups = [
		"File",
		"Start",
		"Shutdown",
		"Restart",
		"Close",
		"Tutorial",
		"Internet",
		"Trash"
	]
	
	for g in group:
		if g in possible_groups:
			return g

func on_icons_pressed(group,b_name):
	$MouseClick.play()
	var element = get_group_element(group)
	match element:
		"File":
			if locked[b_name] in ["Unlocked"]:
				var scene = open_scene(b_name)
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
				toggle_icon_infection(
					get_tree().get_nodes_in_group("Tutorial")[0],
					"Infected"
				)
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

# you can have 2 modes infected and uninfected one
# You have to pass the mode in strings
# Infected and Uninfected
func toggle_icon_infection(i, status):
	var current_group=i.get_groups()
	var elements=""
	for element in current_group:
		if element in ["File","Trash","Tutorial","BackGround","Internet"]:
			elements=element
			
	var resource
	var has_changed : bool
	if elements!="File":
		resource=load(Pc_stats[elements][status])
		if i is TextureRect:
			has_changed = not i.texture.load_path == resource.load_path
			i.texture=resource
		else:
			has_changed = not i.texture_normal.load_path == resource.load_path
			i.texture_normal=resource
	else:
		resource = load(Pc_stats[elements][status][locked[i.name]])
		has_changed = not i.texture_normal.load_path == resource.load_path
		i.texture_normal=resource
	
	if status == 'Infected' and has_changed:
		$Glitch.play()
		i.material = ShaderMaterial.new()
		i.material.shader = GlitchShader
		i.material.set_shader_param("shake_power", 0.157)
		i.material.set_shader_param("shake_rate	", 0.933)
		i.material.set_shader_param("shake_block", 1.237)
		
		yield(get_tree().create_timer(1.5),"timeout")
		i.material.shader = null


func toggle_all_icons(status):
	for i in get_tree().get_nodes_in_group("Infectable"):
		toggle_icon_infection(i, status)


func _on_Pc_gui_input(event):
	if (event is InputEventMouseButton && event.pressed):
		$MouseClick.play()


func unlock_area(i):
	toggle_icon_infection(i, "Uninfected")

func _on_Virus_area_unlocked(area):
	Global.locked_status[area.name] = "Unlocked"
	unlock_area(area.get_parent())
