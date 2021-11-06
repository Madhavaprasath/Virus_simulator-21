extends Node2D

func _ready():
	Global.connect("spwan_bullet_direction",self,"_spwan_bullet_direction")

func _spwan_bullet_direction(bullet,position,dir,rotation=0,mode=1):
	if mode==1:
		var child_bullet=bullet.instance()
		child_bullet.position=position
		child_bullet.start(dir)
		add_child(child_bullet)
	elif mode!=1:
		var c_g=bullet.instance()
		c_g.global_position=position
		c_g.fired=true
		c_g.rotation=rotation
		c_g.tracking_target=dir


func _on_Area2D_body_entered(body):
	get_tree().change_scene("res://Platformer/Scenes/Finale/Finale-level1.tscn")
