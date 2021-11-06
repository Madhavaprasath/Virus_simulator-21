extends Sprite

var rotate_speed = 3
var _rotate_speed = 0
var radius = 230
var _centre
var _angle = 0

func _ready():
	set_process(true)
	_centre = self.get_position()

func _process(delta): 
	_angle += _rotate_speed * delta;
	var offset = Vector2(sin(_angle), cos(_angle)) * radius;
	var pos = _centre + offset
	self.set_position(pos)
	_rotate_speed += 0.003


func _on_Area2D_body_entered(body):
	if body.name == 'Virus':
		get_parent().lose()
