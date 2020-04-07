extends KinematicBody

onready var inner_gimbal = find_node("inner_gimbal")

export (float, 0.0, 2.0) var rotation_speed = PI/2

# mouse properties
export (bool) var mouse_control = false
export (float, 0.001, 0.1) var mouse_sensitivity = 0.005
export (bool) var invert_y = false
export (bool) var invert_x = false

# zoom settings
export (float) var max_zoom = 7.0
export (float) var min_zoom = 0.4
export (float, 0.05, 1.0) var zoom_speed = 0.09

export (float) var zoom = (max_zoom - min_zoom) / 2.0 + min_zoom

# fly settings
export (float) var fly_speed = 1.0
export (float) var fly_accel = 1.0

# movement vars
var input_dir := Vector3()
var vel := Vector3()
var accel := Vector3()
var time_since_last_input := 0.0

func _init():
	scale = Vector3.ONE * zoom

func _physics_process(delta):
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		process_input(delta)
		process_movement(delta)
	
	if !mouse_control:
		get_input_keyboard(delta)
	inner_gimbal.rotation.x = clamp(inner_gimbal.rotation.x, deg2rad(-90), deg2rad(90))
	scale = lerp(scale, Vector3.ONE * zoom, zoom_speed)

func process_input(delta:float)->void:
		var dir = Vector3.ZERO
		if Input.is_action_pressed("move_forward"):
			dir += Vector3.FORWARD
		elif Input.is_action_pressed("move_backward"):
			dir += Vector3.BACK
		
		if Input.is_action_pressed("move_left"):
			dir += Vector3.LEFT
		if Input.is_action_pressed("move_right"):
			dir += Vector3.RIGHT
		
		if Input.is_action_pressed("move_up"):
			dir += Vector3.UP
		if Input.is_action_pressed("move_down"):
			dir += Vector3.DOWN
		
		input_dir = dir.normalized()
		
		if input_dir.length() > 0.0:
			time_since_last_input = 0.0
			accel = input_dir * fly_accel * delta
		else:
			time_since_last_input += fly_accel * delta
			accel = Vector3.ZERO

func process_movement(delta:float)->void:
	# Velocity calc
	vel += accel
	#-----velocity direction--velocity magnitude--------------------tend toward zero velocity-------------
	vel = vel.normalized() * (clamp(vel.length(), 0.0, fly_speed) * lerp(1.0, 0.0, time_since_last_input))
	
	translate_object_local(vel)

func _unhandled_input(event):
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if mouse_control and event is InputEventMouseMotion:
			if event.relative.x != 0:
				var dir = 1 if invert_x else -1
				rotate_object_local(Vector3.UP, dir * event.relative.x * mouse_sensitivity)
			if event.relative.y != 0:
				var dir = 1 if invert_y else -1
				var y_rotation = clamp(event.relative.y, -30, 30)
				inner_gimbal.rotate_object_local(Vector3.RIGHT, dir * y_rotation * mouse_sensitivity)
	
	if event.is_action_pressed("cam_zoom_in"):
		zoom -= zoom_speed
	if event.is_action_pressed("cam_zoom_out"):
		zoom += zoom_speed
	zoom = clamp(zoom, min_zoom, max_zoom)

func get_input_keyboard(delta):
	pass
