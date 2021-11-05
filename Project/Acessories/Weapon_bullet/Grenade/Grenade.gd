extends KinematicBody2D

var direction=Vector2()
var shot=false
var velocity=Vector2()
var exploded =false
export (int) var Speed=400
export (int) var damage=15
var states=["Shoot","Explode"]
var current_state=""

func _physics_process(delta):
	if shot:
		velocity=direction*Speed 
		velocity.y+=1000*delta
	if is_on_floor()||is_on_wall():
		states="Explode"
		velocity=Vector2()
		shot=false
	if states in ["Explode"] && !exploded:
		exploded=true
		initiate_explotion()
	velocity=move_and_slide(velocity,Vector2.UP)
func start(dir):
	rotation=dir.angle()
	direction=dir
	current_state=states[0]
	shot=true

func initiate_explotion():
	$Timer.start(3)
	$AnimationPlayer.play("Rapid")

func _on_Timer_timeout():
	$destruction_area/CollisionShape2D.set_deferred("disabled",false)
	yield(get_tree().create_timer(0.2),"timeout")
	queue_free()

func _on_destruction_area_body_entered(body):
	print(body.name)
	if body.is_in_group("can_damage"):
		body.change_health(damage)
