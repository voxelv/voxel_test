extends Spatial

onready var inner_gimbal = find_node("inner_gimbal")

export (float, 0.0, 2.0) var rotation_speed = PI/2

# mouse properties
export (bool) var mouse_control = false
export (float, 0.001, 0.1) var mouse_sensitivity = 0.005
export (bool) var invert_y = false
export (bool) var invert_x = false

func _init():
	pass

func _process(delta):
	if !mouse_control:
		get_input_keyboard(delta)
	inner_gimbal.rotation.x = clamp(inner_gimbal.rotation.x, deg2rad(-90), deg2rad(90))

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
				var y_rotation = event.relative.y
				inner_gimbal.rotate_object_local(Vector3.RIGHT, dir * y_rotation * mouse_sensitivity)

func get_input_keyboard(delta):
	pass
