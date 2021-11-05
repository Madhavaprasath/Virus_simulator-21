extends Node2D

onready var virus=get_node("Virus")

func _ready():
	virus.get_node("Camera2D").current = true
