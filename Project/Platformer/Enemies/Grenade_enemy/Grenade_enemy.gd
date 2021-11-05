extends "res://Platformer/Enemies/Enemies.gd"

onready var grenade=get_node("Body/Grenede_launcher").grenade

func _ready():
	pass
func Attack_player():
	if player:
		var dir=global_position.direction_to(player.global_position)
		direction=dir.x
		$Body.scale.x=sign(dir.x)
		velocity=Vector2()
		var pos=get_node("Body/Grenede_launcher/Position2D").global_position
		Global.emit_signal("spwan_bullet_direction",grenade,pos,dir,0,1)
		$reload_timer.start()

func _on_reload_timer_timeout():
	can_shoot=true
