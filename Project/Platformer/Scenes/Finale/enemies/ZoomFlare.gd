extends Node2D

var move_speed := 0
var cant_get_past = null

func _physics_process(delta):
	if move_speed and cant_get_past:
		position.x += move_speed * delta
		if move_speed > 0 and position.x >= cant_get_past:
			queue_free()
		elif move_speed < 0 and position.x <= cant_get_past:
			queue_free()

func _on_Node2D_body_entered(body):
	if body.name == "Virus":
		get_parent().lose()
