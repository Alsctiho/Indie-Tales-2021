extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var playerNode

const ACCEL = 1000
var MAX_SPEED = 250
var motion = Vector2.ZERO

var health = 10

const KNOCK_BACK_ACCEL = 1500
const KNOCK_BACK_TIME = 0.5
var knockback = Vector2.ZERO

const APPEAR_TIME = 0.5

var opacity = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	playerNode = get_node("/root/World/Player")
	opacity = 0
	$Sprite.modulate = Color(1.0, 1.0, 1.0, opacity)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func apply_movement(acceleration):
	motion += acceleration
	motion = motion.clamped(MAX_SPEED)

func _process(delta):
	
	opacity = clamp(lerp(0, 1, opacity + 1 / APPEAR_TIME * delta), 0, 1)
	
	if knockback != Vector2.ZERO:
		$Sprite.modulate = Color(1.0, 0.5, 0.5, opacity)
	else:
		$Sprite.modulate = Color(1.0, 1.0, 1.0, opacity)
		
func _physics_process(delta):
	look_at(playerNode.position)
	
	knockback = knockback.move_toward(Vector2.ZERO, delta / KNOCK_BACK_TIME)
#	self.position += knockback * delta
	motion += knockback * KNOCK_BACK_ACCEL * delta
	
	var dir = (playerNode.position - position).normalized()
	apply_movement(dir * ACCEL * delta)
	motion = move_and_slide(motion)

func take_damage(damage):
	health = health - damage
	if health <= 0:
		explode()

func _on_Hitbox_body_entered(bullet):
	knockback = Vector2(1, 0)
	knockback = knockback.rotated(bullet.rotation)
	
	take_damage(bullet.damage)
	bullet.queue_free()
#	queue_free()
	
func explode():
	playerNode.gain_money(1)
	playerNode.gain_score(10)
	queue_free()
