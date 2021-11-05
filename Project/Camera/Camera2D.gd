extends Camera2D


func _ready():
	for i in get_tree().get_nodes_in_group("virus"):
		i.connect("change_camera",self,"On_changing_camera")


func On_changing_camera():
	$Area2D/CollisionShape2D.disabled=true
	$Tween.interpolate_property(self,"position:x",global_position.x,(global_position.x+1024-50),Tween.TRANS_SINE,Tween.EASE_IN_OUT,0.3)
	$Tween.start()
	yield($Tween,"tween_completed")
	$Area2D/CollisionShape2D.disabled=false
func _on_Area2D_body_entered(body):
	On_changing_camera()
	pass
