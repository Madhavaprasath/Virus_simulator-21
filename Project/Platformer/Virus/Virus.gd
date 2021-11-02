extends KinematicBody2D

var speed := 500.0
var jump_impulse := 600.0
var base_gravity := 1000.0

var _velocity := Vector2.ZERO

enum states{
	IDLE,
	MOVE,
	JUMPING,
	FALL
}
var previous_state
var current_state
var input_direction_x
func _ready():
	current_state = states.IDLE

func _physics_process(delta: float) -> void:
	input_direction_x = check_input()
	apply_gravity(delta)
	apply_velocity(delta)

func apply_gravity(delta):
	# Calculating vertical velocity.
	_velocity.y += base_gravity * delta

func apply_velocity(delta):
	_velocity.x = lerp(_velocity.x,input_direction_x*speed,1-pow(0.0001,delta))
	_velocity = move_and_slide(_velocity,Vector2.UP)

func match_state():
	match current_state:
		states.IDLE:
			if input_direction_x !=0:
				return states.MOVE
			if _velocity.y < 0:
				return states.JUMPING
			elif _velocity.y > 0:
				return states.FALL
		states.MOVE:
			if input_direction_x == 0:
				return states.IDLE
			if _velocity.y < 0:
				return states.JUMPING
			elif _velocity.y > 0:
				return states.FALL
		states.JUMPING:
			if _velocity.y < 0:
				return states.JUMPING
		states.FALL:
			if is_on_floor():
				return states.IDLE
	return null 

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
