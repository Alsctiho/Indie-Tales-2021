extends KinematicBody2D

var MAX_SPEED = 400
var ACCELERATION = 3000
var FRICTION = 3000
var motion = Vector2()

var hit_axis = Vector2()

const HIT_TIME = 0.5
const HIT_ACCEL = 8000
const HIT_FRICTION = 3000
const HIT_DISTANCE = 1.5

var health = 10
var money = 0

enum PLAYER_STATE {
	hit,
	move
}

var state = PLAYER_STATE.move
var timer = null

var bullet_speed = 2000
var bullet_scene = preload("res://Scenes/Bullets/Bullets.tscn")
var portal_bullet_scene = preload("res://Scenes/Portals/PortalBullet.tscn")

export (NodePath) var Portal1
export (NodePath) var Portal2

var is_portal_1 = true

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("Hitbox").connect("body_entered", self, "_on_Hitbox_body_entered")
	z_index = 5
	gain_money(20)

func _process(delta):
	if Input.is_action_just_pressed("fire"):
		fire()
	if Input.is_action_just_pressed("ui_select"):
		fire_portal()
		
#	print((get_global_mouse_position() - position).normalized())
#	print(atan2((get_global_mouse_position() - position).normalized().y, (get_global_mouse_position() - position).normalized().x))
#	print(rotation)

func _physics_process(delta):
	
	match state:
		PLAYER_STATE.move:
			var axis = get_input_axis()
			if axis == Vector2.ZERO:
				apply_friction(FRICTION * delta)
		#		pass
			else:
				apply_movement(axis * ACCELERATION * delta)
			
		#	var hit_axis = Vector2(1, 0)
		#	apply_hit_movement(hit_axis * ACCELERATION * delta)
			motion = move_and_slide(motion)
		
			look_at(get_global_mouse_position())
		PLAYER_STATE.hit:
			apply_movement(hit_axis * HIT_ACCEL * (timer.time_left / HIT_TIME) * delta)
			apply_friction(HIT_FRICTION * delta)
			motion = move_and_slide(motion)
			rotation = atan2(-hit_axis.y, -hit_axis.x)

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

func get_hit(dir):
#	print("Got Hit")
#	print(dir)
#	print(atan2(-dir.x, -dir.y))
	hit_axis = dir
	state = PLAYER_STATE.hit
	$Sprite.modulate = Color(1.0, 0.5, 0.5, 1.0)
	
	health = health - 1
	update_health()
	
	if !(timer):
		timer = Timer.new()
		timer.wait_time = HIT_TIME
		#timeout is what says in docs, in signals
		#self is who respond to the callback
		#_on_timer_timeout is the callback, can have any name
		timer.connect("timeout",self,"_on_timer_timeout")
		add_child(timer) #to process
		
	timer.start() #to start
	
func update_health():
	print("HP: " + String(health))
	if (health <= 0):
		get_tree().reload_current_scene()

func _on_timer_timeout():
#	print("Move!")
	state = PLAYER_STATE.move
	$Sprite.modulate = Color(1.0, 1.0, 1.0, 1.0)
	
	timer.stop()

func _on_Hitbox_body_entered(monster):
#	print(body)
	
	get_hit((position - monster.position).normalized() * HIT_DISTANCE)
	monster.explode()

func gain_money(amount):
	money += amount
	print("Money: " + String(money))
	
func use_money(amount) -> bool:
	if (money >= amount):
		# can use money
		money -= amount
		return true
	else:
		return false
