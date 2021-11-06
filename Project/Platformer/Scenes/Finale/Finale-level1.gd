extends Node2D

var PREFIX = "res://Platformer/Scenes/Finale/enemies/"

onready var Pencil=load(PREFIX + "Pencil.tscn")
onready var ZoomFlare=load(PREFIX + "ZoomFlare.tscn")
onready var Eraser=load(PREFIX + "Eraser.tscn")

onready var virus=get_node("Virus")
onready var timer=get_node("AttackTimer")

onready var GlitchShader = preload("res://Computer/glitch_effect.shader").duplicate(true)

var has_won := false
var curr_fight = 0
var fights_script = [
	# STEP 1: PENCILS
	["pencil_barrage1", 1], # Function name, wait time before calling it
	["pencil_barrage2", 0.7],
	["pencil_barrage3", 1],
	["pencil_railgun", 1, {
		"pos": Vector2(180, 149),
		"impulse": Vector2(400, 400),
		"flip_h": true,
	}], # Third argument is for parameters
	["pencil_railgun", 0.3, {
		"pos": Vector2(959, 303),
		"impulse": Vector2(-400, 400),
		"flip_h": false,
	}],
	["pencil_railgun", 0.4, {
		"pos": Vector2(180, 250),
		"impulse": Vector2(400, 400),
		"flip_h": true,
	}],
	["pencil_railgun", 0.2, {
		"pos": Vector2(959, 403),
		"impulse": Vector2(-400, 400),
		"flip_h": false,
	}],
	# STEP 2: FLOOD
	["zoom_flare", 2],
	["eraser_dance", 7],
	["pencil_barrage1", 2], # Function name, wait time before calling it
	["pencil_barrage2", 1],
	["pencil_barrage3", 0.6],
	["pencil_railgun", 0.7, {
		"pos": Vector2(180, 149),
		"impulse": Vector2(400, 400),
		"flip_h": true,
	}], # Third argument is for parameters
	["pencil_railgun", 0.3, {
		"pos": Vector2(959, 303),
		"impulse": Vector2(-400, 400),
		"flip_h": false,
	}],
	["pencil_railgun", 0.4, {
		"pos": Vector2(180, 250),
		"impulse": Vector2(400, 400),
		"flip_h": true,
	}],
	["pencil_railgun", 0.2, {
		"pos": Vector2(959, 403),
		"impulse": Vector2(-400, 400),
		"flip_h": false,
	}],
	["pencil_barrage1", 1], # Function name, wait time before calling it
	["pencil_barrage2", 0.2],
	["pencil_barrage3", 1.5],
	["pencil_railgun", 2, {
		"pos": Vector2(180, 149),
		"impulse": Vector2(400, 400),
		"flip_h": true,
	}], # Third argument is for parameters
	["pencil_railgun", 0.4, {
		"pos": Vector2(959, 303),
		"impulse": Vector2(-400, 400),
		"flip_h": false,
	}],
	["pencil_railgun", 0.5, {
		"pos": Vector2(180, 250),
		"impulse": Vector2(400, 400),
		"flip_h": true,
	}],
	["pencil_railgun", 0.3, {
		"pos": Vector2(959, 403),
		"impulse": Vector2(-400, 400),
		"flip_h": false,
	}],
	
]

func _ready():
	virus.get_node("CanvasLayer/HealthUI").visible = false
	virus.get_node("Raycast/weapons").visible = false
	next_fight()
	
func next_fight():
	if not has_won:
		timer.wait_time = fights_script[curr_fight][1]
		timer.start()

func start_fight():
	if not curr_fight >= len(fights_script):
		if len(fights_script[curr_fight]) == 3 :
			call(fights_script[curr_fight][0], fights_script[curr_fight][2])
		else:
			call(fights_script[curr_fight][0])
		curr_fight += 1
		if curr_fight > len(fights_script) - 1:
			print(curr_fight)
			win()
		else:
			next_fight()

func win():
	has_won = true
	var erasers = get_tree().get_nodes_in_group("eraser")
	for e in erasers:
		e.queue_free()
	glitch_background()

func glitch_background():
	var glitched = load("res://Computer/BackGround/BackgroundHELP.png")
	var normal = load("res://Platformer/Scenes/Finale/peint.png")
	$Glitch.play()
	$Sprite.set_texture(glitched)
	yield(get_tree().create_timer(0.5), "timeout")
	$Sprite.set_texture(normal)
	yield(get_tree().create_timer(0.3), "timeout")
	$Sprite.set_texture(glitched)
	yield(get_tree().create_timer(0.2), "timeout")
	$Sprite.set_texture(normal)
	yield(get_tree().create_timer(0.2), "timeout")
	
	get_tree().change_scene("res://Platformer/Scenes/Goodbye.tscn")
	
func lose():
	get_tree().reload_current_scene()

func pencil_barrage1():
	var n_pencils = 10
	var pencils = []
	
	var x = 90
	var y = 85
	
	var p
	for n in n_pencils:
		p = Pencil.instance()
		add_child(p)
		p.set_gravity_scale(0)
		p.apply_impulse(Vector2.ZERO, Vector2(350, 350))
		p.position = Vector2(x, y)
		p.sprite.flip_h=true
		pencils.append(p)
		x += 30

func pencil_barrage2():
	var n_pencils = 10
	var pencils = []
	
	var x = 1000
	var y = 85
	
	var p
	for n in n_pencils:
		p = Pencil.instance()
		add_child(p)
		p.set_gravity_scale(0)
		p.apply_impulse(Vector2.ZERO, Vector2(-350, 350))
		p.position = Vector2(x, y)
		p.sprite.flip_h=false
		pencils.append(p)
		x -= 30
		
func pencil_barrage3():
	var n_pencils = 20
	var pencils = []
	
	var x = 85
	var y = 85
	
	var p
	for n in n_pencils:
		p = Pencil.instance()
		add_child(p)
		p.set_gravity_scale(0)
		p.apply_impulse(Vector2.ZERO, Vector2(350, 350))
		p.position = Vector2(x, y)
		p.sprite.flip_h=true
		pencils.append(p)
		x += 40
		
func pencil_railgun(args):
	var p = Pencil.instance()
	add_child(p)
	p.set_gravity_scale(0)
	p.apply_impulse(Vector2.ZERO, args["impulse"])
	p.position = args["pos"]
	p.sprite.flip_h=args["flip_h"]
	
func zoom_flare():
	var zf1 = ZoomFlare.instance()	
	add_child(zf1)
	zf1.set_gravity_scale(0)
	zf1.position = Vector2(108, 80)
	zf1.move_speed = 100
	zf1.cant_get_past = 450
	
	var zf2 = ZoomFlare.instance()	
	add_child(zf2)
	zf2.set_gravity_scale(0)
	zf2.position = Vector2(916, 80)
	zf2.move_speed = -100
	zf2.cant_get_past = 600
	
func eraser_dance():
	var e1 = Eraser.instance()
	e1.position = Vector2(542, 284)
	e1.radius = 230
	e1._angle = 0+45
	add_child(e1)

	var e2 = Eraser.instance()
	e2.position = Vector2(542, 284)
	e2.radius = 230
	e2._angle = 360+45
	add_child(e2)
	
	var e3 = Eraser.instance()
	e3.position = Vector2(542, 284)
	e3.radius = 230
	e3._angle = 720+45
	add_child(e3)
