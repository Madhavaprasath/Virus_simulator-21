extends KinematicBody2D

const Speed=200.0


enum{
	IDLE,
	WALK,
	ATTACK
}

var direction=1
var current_state=IDLE
var velocity=Vector2()
var base_gravity := 1200.0
onready var body=get_node("Body")


func _ready():
	pass

func _physics_process(delta):
	match_state(delta)
	velocity.y+=base_gravity*delta
	velocity=move_and_slide(velocity,Vector2.UP)
func match_state(delta):
	match current_state:
		IDLE:
			velocity.x=lerp(velocity.x,0,1-pow(0.0001,0.5))
		WALK:
			velocity.x=lerp(velocity.x,Speed*direction,0.5)
			check_direction()
		ATTACK:
			Attack_player()
func Attack_player():
	pass

func check_direction():
	if (!$Body/RayCast2D.is_colliding() && is_on_floor())|| is_on_wall():
		direction*=-1
		$Body.scale.x*=-1


func random_state(Arr):
	randomize()
	Arr.shuffle()
	return Arr.pop_front()

func _on_Timer_timeout():
	if current_state !=ATTACK:
		$Timer.wait_time=random_state([3,4,4.5])
		current_state=random_state([IDLE,WALK])

