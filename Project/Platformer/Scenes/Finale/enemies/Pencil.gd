extends RigidBody2D

onready  var sprite=get_node("Sprite")
onready var hurbox=get_node("Hurtbox") 

func _on_Pencil_body_entered(body):
	if body.name == "WALLS":
		queue_free()
	elif body.name == "Virus":
		get_parent().lose()
