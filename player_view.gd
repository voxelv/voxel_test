extends Spatial

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
export (float) var fly_speed = 20.0

func _init():
	scale = Vector3.ONE * zoom

func _process(delta):
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		var movement := Vector3.ZERO
		if Input.is_action_pressed("move_forward"):
	#		movement += $inner_gimbal.transform.xform(Vector3.FORWARD)
			movement += Vector3.FORWARD
		elif Input.is_action_pressed("move_backward"):
	#		movement += $inner_gimbal.transform.xform(Vector3.BACK)
			movement += Vector3.BACK
		
		if Input.is_action_pressed("move_left"):
			movement += Vector3.LEFT
		if Input.is_action_pressed("move_right"):
			movement += Vector3.RIGHT
		
		# calculate horizontal movement normalized
		movement = movement.normalized() * delta * fly_speed
		
		var vertical_movement := Vector3.ZERO
		if Input.is_action_pressed("move_up"):
			vertical_movement += Vector3.UP
		if Input.is_action_pressed("move_down"):
			vertical_movement += Vector3.DOWN
		
		movement += vertical_movement * delta * fly_speed
		translate_object_local(movement)
	
	if !mouse_control:
		get_input_keyboard(delta)
	inner_gimbal.rotation.x = clamp(inner_gimbal.rotation.x, deg2rad(-90), deg2rad(90))
	scale = lerp(scale, Vector3.ONE * zoom, zoom_speed)

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
