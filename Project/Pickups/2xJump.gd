extends "res://Pickups/Pickups.gd"

func do_pick_up_stuff(body):
	$CollisionShape2D.set_deferred("disabled",true)
	visible=false
	body.jump_impulse=750
	yield(get_tree().create_timer(2),"timeout")
	body.jump_impulse=600
	queue_free()
