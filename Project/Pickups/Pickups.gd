extends Area2D



func _on_Pickup_body_entered(body):
	do_pick_up_stuff(body)
	queue_free()

func do_pick_up_stuff(body):
	pass
