extends "res://Pickups/Pickups.gd"


export (String) var Gun_name=""


func do_pick_up_stuff(body):
	body.current_weapon=Gun_name
