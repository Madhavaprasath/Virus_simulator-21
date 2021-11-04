extends "res://Platformer/Enemies/Enemies.gd"

onready var grenade=get_node("Body/Grenede_launcher").grenade

func _ready():
	pass
func Attack_player():
	if player:
		var direction=global_position.direction_to(player.global_position-Vector2(100,0))
		$Body.scale.x=sign(direction.x)
		velocity=Vector2()
		var c_g=grenade.instance()
		c_g.global_position=get_node("Body/Grenede_launcher/Position2D").global_position
		c_g.start(Vector2(direction.x,0),player.global_position)
		get_parent().add_child(c_g)
		$reload_timer.start()

func _on_reload_timer_timeout():
	can_shoot=true
