extends Spatial

export(int) var snap_multiple = 2

onready var mover := find_node("mover") as Spatial

var max_dist := 7.0
var mod_dist := 2

func _ready():
	pass

func _process(delta):
	move_mover()

func setup(max_dist:float, mod_dist:int)->void:
	self.max_dist = max_dist
	self.mod_dist = mod_dist

func move_mover():
	var v = global_transform.origin
	
	v = round_to_nrst_v3(v)

	mover.global_transform.origin = Vector3(float(int(v.x)), float(int(v.y)), float(int(v.z)))

	var d = (mover.transform.origin + transform.origin).length()
	var s = range_lerp(d, 0.0, max_dist, 1.0, 0.001)
	mover.transform.basis = Basis.IDENTITY.scaled(Vector3(s, s, s))

func round_to_nrst_v3(v:Vector3)->Vector3:
	var new_v = Vector3.ZERO
	
	new_v.x = round(v.x/float(mod_dist))*mod_dist
	new_v.y = round(v.y/float(mod_dist))*mod_dist
	new_v.z = round(v.z/float(mod_dist))*mod_dist
	
	return(new_v)
