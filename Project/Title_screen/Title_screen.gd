extends Control

func _on_User1_input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton && event.pressed):
		$TextureRect.texture = load("res://Title_screen/start_page_clicked.png")
		$Login.play()
		yield($Login, "finished")
		get_tree().change_scene("res://Computer/Computer.tscn")

func _on_User2_input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton && event.pressed):
		print("Logo clicked")

func _on_TurnOff_input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton && event.pressed):
		$Goodbye.play()
		yield($Goodbye, "finished")
		get_tree().quit()
