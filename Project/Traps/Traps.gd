extends Area2D


func _on_Traps_body_entered(body):
	body.change_health(100)
