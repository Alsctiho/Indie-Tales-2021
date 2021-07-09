extends KinematicBody2D

var MAX_SPEED = 400
var ACCELERATION = 3000
var FRICTION = 5000
var motion = Vector2()

var bullet_speed = 2000
var bullet_scene = preload("res://Scenes/Bullets/Bullets.tscn")
var portal_bullet_scene = preload("res://Scenes/Portals/PortalBullet.tscn")

export (NodePath) var Portal1
export (NodePath) var Portal2

var is_portal_1 = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	if Input.is_action_just_pressed("fire"):
		fire()
	if Input.is_action_just_pressed("ui_select"):
		fire_portal()

func _physics_process(delta):
	var axis = get_input_axis()
	if axis == Vector2.ZERO:
		apply_friction(FRICTION * delta)
	else:
		apply_movement(axis * ACCELERATION * delta)
	motion = move_and_slide(motion)
	
	look_at(get_global_mouse_position())

func get_input_axis():
	var axis = Vector2.ZERO
	axis.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	axis.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	
	return axis.normalized()
	
func apply_friction(amount):
	if motion.length() > amount:
		motion -= motion.normalized() * amount
	else:
		motion = Vector2.ZERO

func apply_movement(acceleration):
	motion += acceleration
	motion = motion.clamped(MAX_SPEED)

func fire():
	var bullet_instance = bullet_scene.instance()
	bullet_instance.position = position
	bullet_instance.rotation = rotation
	bullet_instance.apply_impulse(Vector2.ZERO, Vector2(bullet_speed, 0).rotated(rotation))
	get_parent().add_child(bullet_instance)
	
func fire_portal():
	var bullet_instance = portal_bullet_scene.instance()
	bullet_instance.position = position
	bullet_instance.rotation = rotation
	if (is_portal_1):
		is_portal_1 = !is_portal_1
		bullet_instance.portal_path = Portal1
		bullet_instance.get_node("Sprite").modulate = Color(0, 0, 1, 1)
	else:
		is_portal_1 = !is_portal_1
		bullet_instance.portal_path = Portal2
		bullet_instance.get_node("Sprite").modulate = Color(1, 0, 0, 1)
		
	bullet_instance.apply_impulse(Vector2.ZERO, Vector2(bullet_speed, 0).rotated(rotation))
	get_parent().add_child(bullet_instance)