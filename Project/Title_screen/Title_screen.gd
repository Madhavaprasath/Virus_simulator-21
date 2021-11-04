extends Control

func _on_User1_input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton && event.pressed):
		get_tree().change_scene("res://Computer/Computer.tscn")

func _on_User2_input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton && event.pressed):
		print("Logo clicked")

func _on_TurnOff_input_event(viewport, event, shape_idx):
	get_tree().quit()
