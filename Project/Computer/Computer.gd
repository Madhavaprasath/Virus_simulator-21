extends Control

func _ready():
	for button in get_tree().get_nodes_in_group("Icons"):
		button.connect("pressed",self,"on_icons_pressed",[button.get_groups(),button.name])

func on_icons_pressed(group,b_name):
	match group[1]:
		"File":
			print(b_name)
		"Internet":
			OS.shell_open("https://www.youtube.com/watch?v=dQw4w9WgXcQ")
