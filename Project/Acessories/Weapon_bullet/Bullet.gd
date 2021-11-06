extends Area2D

var direction=Vector2()
var shot=false
export (int) var Speed=400
export (int) var damage=5



func _physics_process(delta):
	if shot:
		position+=(direction*Speed)*delta
func start(dir):
	rotation=dir.angle()
	direction=dir
	shot=true


func destroy_mechs():
	queue_free()


func _on_Timer_timeout():
	destroy_mechs()


func _on_Bullets_body_entered(body):
	if body.is_in_group("can_damage"):
		body.change_health(damage)
	rocketmechs()
	destroy_mechs()

func rocketmechs():
	pass
