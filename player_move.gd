extends KinematicBody

# fly settings
export (float) var fly_speed = 1.0
export (float) var fly_accel = 1.0

# nodes to reference
onready var camera_control = find_node("camera_control")

# movement vars
var input_dir := Vector3()
var vel := Vector3()
var accel := Vector3()
var time_since_last_input := 0.0

func _ready():
	pass

func _physics_process(delta):
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		process_input(delta)
		process_movement(delta)

func process_input(delta:float)->void:
	var was_input := false
	var dir = Vector3.ZERO
	if Input.is_action_pressed("move_forward"):
		dir += Vector3.FORWARD; was_input = true
	elif Input.is_action_pressed("move_backward"):
		dir += Vector3.BACK; was_input = true
	
	if Input.is_action_pressed("move_left"):
		dir += Vector3.LEFT; was_input = true
	if Input.is_action_pressed("move_right"):
		dir += Vector3.RIGHT; was_input = true
	
	if Input.is_action_pressed("move_up"):
		dir += Vector3.UP; was_input = true
	if Input.is_action_pressed("move_down"):
		dir += Vector3.DOWN; was_input = true
	
	input_dir = dir.normalized()
	
	if was_input:
		time_since_last_input = 0.0
		accel = camera_control.transform.xform(input_dir) * fly_accel * delta
		accel = accel
	else:
		time_since_last_input += fly_accel * delta * 0.5
#		vel = Vector3.ZERO
		accel = Vector3.ZERO

func process_movement(delta:float)->void:
	# Change velocity based on acceleration
	vel += accel
	#-----velocity direction--velocity magnitude--------------------tend toward zero velocity-------------
	vel = vel.normalized() * (clamp(vel.length(), 0.0, fly_speed) * clamp(lerp(1.0, 0.0, time_since_last_input), 0.0, 1.0))
	
	# Change position based on velocity
#	translate(vel)
#	translate_object_local(vel)
	vel = move_and_slide(vel, Vector3.UP, false, 4, 0.78, true)
