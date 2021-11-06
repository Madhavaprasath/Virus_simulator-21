extends "res://Pickups/Pickups.gd"


export (String) var Gun_name=""


func do_pick_up_stuff(body):
	body.change_gun(Gun_name)
