extends KinematicBody2D

var speed := 500.0
var jump_impulse := 1200.0
var base_gravity := 1000.0

var _velocity := Vector2.ZERO


func _physics_process(delta: float) -> void:
	# Starting with input.
	var input_direction_x: float = (
		Input.get_action_strength("move_right")
		- Input.get_action_strength("move_left")
	)
	var is_jumping := is_on_floor() and Input.is_action_just_pressed("move_up")

	# Calculating horizontal velocity.
	_velocity.x = input_direction_x * speed
	# Calculating vertical velocity.
	_velocity.y += base_gravity * delta
	if is_jumping:
		_velocity.y = -jump_impulse
	# Moving the character.
	_velocity = move_and_slide(_velocity)
