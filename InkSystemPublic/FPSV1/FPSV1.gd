extends KinematicBody

# FPS Controller
# based on: https://www.youtube.com/watch?v=Nn2mi5sI8bM
# by: Garbaj

var speed = 10
var h_acceleration = 6
var mouse_sensitivity = 0.1
var gravity = 10

var direction = Vector3.ZERO
var h_velocity = Vector3.ZERO

onready var head = $Head
onready var o_inkSystem = get_parent()
onready var o_raycast = $Head/Camera/RayCast



func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)



func _input(event):
	# Camera movement
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotate_y(deg2rad(-event.relative.x * mouse_sensitivity))
		head.rotate_x(deg2rad(-event.relative.y * mouse_sensitivity))
		head.rotation.x = clamp(head.rotation.x, deg2rad(-80), deg2rad(80))
	
	# Mouse capture and uncapture
	# ESC uncaptures the mouse
	# if you click into the window the mouse is captured
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE and Input.is_action_just_pressed("paint1"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)



func _physics_process(delta):
	
	direction = Vector3.ZERO
	direction += transform.basis.z * (Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward"))
	direction += transform.basis.x * (Input.get_action_strength("move_right") - Input.get_action_strength("move_left"))
	
	direction = direction.normalized()
	h_velocity = h_velocity.linear_interpolate(direction * speed, h_acceleration * delta)
	var movement = Vector3(0,0,0)
	movement.z = h_velocity.z
	movement.y = -gravity
	movement.x = h_velocity.x
	
	movement = move_and_slide(movement, Vector3.UP)



func _process(_delta):
	paint()



# Paint method
# left mouse button (paint1): paint
# right mouse button (paint2): erase
func paint():
	var paintPos = o_raycast.get_collision_point()
	if paintPos:
		# paint
		if Input.get_action_strength("paint1") and o_raycast.is_colliding():
			SignalBus.emit_signal("paintSignal", paintPos, 2.0, Color(1,0,0,1))
		
		# erase
		if Input.get_action_strength("paint2") and o_raycast.is_colliding():
			SignalBus.emit_signal("paintSignal", paintPos, 2.0, Color(0,1,0,1))



func get_collision_point():
	if o_raycast.is_colliding():
		return o_raycast.get_collision_point()
	else:
		return null
