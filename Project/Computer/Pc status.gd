extends Node2D

var states=["Infected","Uninfected"]
signal change_pc_status(status)
var pc_stats="Uninfected"

var icons={
	"File":{
		"Infecteed":{
			"Locked":"res://Computer/Icons/f01der.png",
			"Unlocked":"res://Computer/Icons/f01derLocked.png"
		},
		"Uninfected":{
			"Locked":"res://Computer/Icons/folder.png",
			"Unlocked":"res://Computer/Icons/folderLocked.png"
		}
	},
	"BackGround":{
		"Infected":"res://Computer/BackGround/BackgroundHELP.png",
		"Uninfected":"res://Computer/BackGround/Background.png"
	},
	"Tutorial":{
		"Infected":"res://Computer/Icons/Notepad.png",
		"Uninfected":"res://Computer/Icons/N0tepad.png"
	},
	"Trash":{
		"Infected":"res://Computer/Icons/TRs8_y0n_can1.png",
		"Uninfected":"res://Computer/Icons/trash_can.png"
	},
	"Internet":{
		"Infected":"res://Computer/Icons/Br0wer.png",
		"Uninfected":"res://Computer/Icons/Browser.png"
	}
}

func _ready():
	emit_signal("change_pc_status","Uninfected")
