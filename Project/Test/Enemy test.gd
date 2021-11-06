extends TileMap

func _ready():
	Global.connect("spwan_bullet_direction",self,"_spwan_bullet_direction")

func _spwan_bullet_direction(bullet,pos,dir,rot=0,mode=1):
	if mode==1:
		var child_bullet=bullet.instance()
		child_bullet.position=pos
		child_bullet.start(dir)
		add_child(child_bullet)
	elif mode==2:
		var c_g=bullet.instance()
		c_g.global_position=pos
		c_g.fired=true
		c_g.rotation=rot
		c_g.tracking_target=dir
		add_child(c_g)
	elif mode==3:
		var child_bullet=bullet.instance()
		child_bullet.position=pos
		print(rot,"Rotate")
		child_bullet.target=rot
		print(child_bullet.target)
		child_bullet.start(dir)
		add_child(child_bullet)
