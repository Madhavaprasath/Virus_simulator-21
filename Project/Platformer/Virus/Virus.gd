extends KinematicBody2D

var speed := 500.0
var jump_impulse := 600.0
var base_gravity := 1000.0

var _velocity := Vector2.ZERO

onready var camera := $Camera2D

signal area_unlocked(area)

enum states{
	IDLE,
	MOVE,
	MOVING_WALL,
	FALLING_WALL,
	JUMPING,
	FALL
}
var previous_state
var current_state
var input_direction_x

var is_hill_disabled := false 
var hill_collision := false

onready var raycast=get_node("Raycast/RayCast2D")

func _ready():
	current_state = states.IDLE

func _physics_process(delta: float) -> void:
	stomping()
	input_direction_x = check_input()
	if current_state in [states.MOVING_WALL,states.FALLING_WALL]:
		apply_wall_velocity(delta)
	flip_raycast()
	apply_gravity(delta)
	apply_velocity(delta)
	var state=match_state()
	if state!=null:
		current_state=state
	if is_hill_disabled and is_on_floor():
		var hill = get_hill()
		if hill:
			hill.disabled = false
			is_hill_disabled = false
			
	var overlapping = $VirusArea.get_overlapping_areas()
	if len(overlapping):
		if 'Area' in overlapping[0].name && Input.is_action_pressed("action"):
			emit_signal("area_unlocked", overlapping[0])

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
	
	var index = get_slide_count() - 1
	if index >= 0:
		var collision = get_slide_collision(index)
		hill_collision = collision && collision.collider.name=="HillCollision"
	else:
		hill_collision = false
	
	var parent = get_parent()
	if hill_collision:
		parent.move_child(self,0)
	elif parent.name == 'TextureRect':
		parent.move_child(self,5)

func apply_wall_velocity(delta):
	if current_state ==states.MOVING_WALL:
		_velocity.y=-speed/4
	else:
		_velocity.y=speed/4

func match_state():
	match current_state:
		states.IDLE:
			if input_direction_x !=0:
				return states.MOVE
			elif input_direction_x!=0 && raycast_colliding():
				return states.MOVING_WALL
			if _velocity.y < 0:
				return states.JUMPING
			elif _velocity.y > 0:
				return states.FALL
		states.MOVE:
			if input_direction_x == 0:
				return states.IDLE
			elif input_direction_x!=0 && raycast_colliding():
				return states.MOVING_WALL
			if _velocity.y < 0:
				return states.JUMPING
			elif _velocity.y > 0:
				return states.FALL
		states.JUMPING:
			if _velocity.y > 0:
				return states.FALL
			if input_direction_x!=0 && raycast_colliding():
				return states.MOVING_WALL
		states.FALL:
			if is_on_floor():
				return states.IDLE
			if input_direction_x!=0 && raycast_colliding():
				return states.FALLING_WALL
		states.MOVING_WALL:
			if !raycast_colliding() || input_direction_x==0:
				return states.IDLE
		states.FALLING_WALL:
			if !raycast_colliding() || input_direction_x==0:
				return states.IDLE

func check_input():
	var input_direction_x: float = (
		Input.get_action_strength("move_right")
		- Input.get_action_strength("move_left")
	)
	return input_direction_x

func drop():
	var hill = get_hill()
	if hill:
		hill.disabled = true
		is_hill_disabled = true
		get_parent().move_child(self, 0)
	
func get_hill():
	var result = get_tree().get_nodes_in_group("HillCollision")
	if len(result):
		return result[0]
	return null

func _unhandled_input(event):
	if event.is_action_pressed("move_up") && is_on_floor():
		_velocity.y =- jump_impulse
	if event.is_action_pressed("move_down") && is_on_floor():
		drop()

func raycast_colliding():
	if raycast.is_colliding():
		var dot=Vector2(0,-1).dot(raycast.get_collision_normal())
		if abs(dot)==0:
			return true
	return false

func stomping():
	for i in get_slide_count():
		var collision=get_slide_collision(i)
		if collision.collider.is_in_group("Enemies"):
			var dot=Vector2(0,-1).dot(collision.normal)
			if abs(dot)==1:
				_velocity.y=-jump_impulse
