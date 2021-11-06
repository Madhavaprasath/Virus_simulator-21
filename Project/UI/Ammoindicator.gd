extends Label

var max_ammo=0

func write_ammo(ammo,max_ammo):
	text=str(ammo)+"/"+str(max_ammo)

func _on_Virus_change_max_ammo(ammo):
	max_ammo=ammo
	write_ammo(ammo,ammo)


func _on_Virus_change_ammo(ammo):
	write_ammo(ammo,max_ammo)
