extends KinematicBody2D

var speed := 500.0
var jump_impulse := 600.0
var base_gravity := 1000.0

var _velocity := Vector2.ZERO

enum states{
	IDLE,
	MOVE,
	MOVING_WALL,
	JUMPING,
	FALL
}
var previous_state
var current_state
var input_direction_x


onready var raycast=get_node("Raycast/RayCast2D")
func _ready():
	current_state = states.IDLE
	print(current_state)

func _physics_process(delta: float) -> void:
	input_direction_x = check_input()
	if current_state == states.MOVING_WALL:
		apply_wall_velocity(delta)
	flip_raycast()
	apply_gravity(delta)
	apply_velocity(delta)
	var state=match_state()
	if state!=null:
		current_state=state
	print(current_state)

func flip_raycast():
	if input_direction_x!=0:
		$Raycast.scale.x=input_direction_x
func apply_gravity(delta):
	# Calculating vertical velocity.
	_velocity.y += base_gravity * delta

func apply_velocity(delta):
	_velocity.x = lerp(_velocity.x,input_direction_x*speed,1-pow(0.0001,delta))
	$Sprite.rotation_degrees=lerp($Sprite.rotation_degrees,$Sprite.rotation_degrees+(15*input_direction_x),0.8)
	_velocity = move_and_slide(_velocity,Vector2.UP)

func apply_wall_velocity(delta):
	_velocity.y=-speed

func match_state():
	match current_state:
		states.IDLE:
			if input_direction_x !=0:
				return states.MOVE
			elif input_direction_x!=0 && raycast_colliding():
				print("hello")
				return states.MOVING_WALL
			if _velocity.y < 0:
				return states.JUMPING
			elif _velocity.y > 0:
				return states.FALL
		states.MOVE:
			if input_direction_x == 0:
				return states.IDLE
			elif input_direction_x!=0 && raycast_colliding():
				print("hello")
				return states.MOVING_WALL
			if _velocity.y < 0:
				return states.JUMPING
			elif _velocity.y > 0:
				return states.FALL
		states.JUMPING:
			if _velocity.y > 0:
				return states.FALL
		states.FALL:
			if is_on_floor():
				return states.IDLE
		states.MOVING_WALL:
			if !raycast_colliding():
				return states.IDLE

func check_input():
	var input_direction_x: float = (
		Input.get_action_strength("move_right")
		- Input.get_action_strength("move_left")
	)
	return input_direction_x

func _unhandled_input(event):
	if event.is_action_pressed("move_up") && is_on_floor():
		_velocity.y =- jump_impulse
		#test ing 

func raycast_colliding():
	if raycast.is_colliding():
		var dot=Vector2(0,-1).dot(raycast.get_collision_normal())
		print(dot,"product")
		if abs(dot)==0:
			return true
	return false
