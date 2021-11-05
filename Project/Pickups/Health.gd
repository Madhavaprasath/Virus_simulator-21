extends "res://Pickups/Pickups.gd"


func do_pick_up_stuff(body):
	randomize()
	body.health+=int(rand_range(30,35))
