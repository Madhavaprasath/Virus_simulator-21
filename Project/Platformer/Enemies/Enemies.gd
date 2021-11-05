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
var player=null
var can_shoot=true

export (int) var health=10
onready var body=get_node("Body")

func _ready():
	pass

func _physics_process(delta):
	if !current_state in [ATTACK,IDLE]:
		$Sprite.rotation_degrees=lerp($Sprite.rotation_degrees,$Sprite.rotation_degrees+(15*direction),0.8)
	if current_state in [IDLE,WALK]:
		velocity=move_and_slide(velocity,Vector2.UP)
	match_state(delta)
	check_direction()
	velocity.y+=base_gravity*delta
func match_state(delta):
	match current_state:
		IDLE:
			velocity.x=lerp(velocity.x,0,1-pow(0.0001,0.5))
			if player:
				current_state=ATTACK
		WALK:
			velocity.x=Speed*direction
			if player:
				current_state=ATTACK
		ATTACK:
			if can_shoot:
				velocity=Vector2()
				Attack_player()
				can_shoot=false
			if player==null:
				current_state=WALK
func Attack_player():
	pass

func check_direction():
	if (!$Body/RayCast2D.is_colliding() && is_on_floor())|| $Body/RayCast2D2.is_colliding():
		direction*=-1
		$Body.scale.x*=-1


func random_state(Arr):
	randomize()
	Arr.shuffle()
	return Arr.pop_front()

func shoot():
	pass

func _on_Timer_timeout():
	if current_state !=ATTACK:
		$Timer.wait_time=random_state([3,4,4.5])
		current_state=random_state([IDLE,WALK])



func _on_Area2D_body_entered(body):
	if body.is_in_group("virus"):
		player=body


func _on_Area2D_body_exited(body):
	if body.is_in_group("virus"):
		player=null

func change_health(damage):
	health-=damage
	emit_signal("change_health",health)
	if health<=0:
		queue_free()
