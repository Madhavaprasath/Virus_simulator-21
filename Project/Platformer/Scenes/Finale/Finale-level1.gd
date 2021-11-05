extends Node2D

var PREFIX = "res://Platformer/Scenes/Finale/enemies/"

onready var Pencil=load(PREFIX + "Pencil.tscn")

onready var virus=get_node("Virus")
onready var timer=get_node("AttackTimer")

var has_won := false
var curr_fight = 0
var fights_script = [
	["pencil_barrage1", 1], # Function name, wait time before calling it
]

func _ready():
	virus.get_node("Camera2D").current = false
	next_fight()
	
func next_fight():
	if not has_won:
		timer.wait_time = fights_script[curr_fight][1]
		timer.start()

func start_fight():
	if not curr_fight >= len(fights_script):
		call(fights_script[curr_fight][0])
		curr_fight += 1
		if curr_fight >= len(fights_script) - 1:
			win()
		else:
			next_fight()

func win():
	has_won = true
	print("You won!")

func pencil_barrage():
	var n_pencils = 5
	var pencils = []
	
	var lim_x = [95, 1000]
	var y = 85
	
	var chosen_index = 0
	var dx = lim_x[chosen_index]
	
	var p
	for n in n_pencils:
		p = Pencil.instance()
		p.position = Vector2(dx, y)
		p.flip_h=bool(not chosen_index)
		pencils.append(p)
		add_child(p)
		dx += -20 if chosen_index else 20
	
	var angle = 45 if chosen_index else -315
	# MAKE THE PENCILS MOVE A IN RAIN
	
func eraser():
	pass
