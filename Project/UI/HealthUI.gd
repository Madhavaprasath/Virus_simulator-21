extends Control

onready var health_over=$HealOver
var h=100






func on_health_updated(health):
	$AnimationPlayer.play("Blink")
	$Tween.interpolate_property(health_over,"value",health_over.value,health,0.5,Tween.TRANS_SINE,Tween.EASE_IN_OUT)
	$Tween.start()




