extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var playerNode

const ACCEL = 1000
var MAX_SPEED = 250
var motion = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	playerNode = get_node("/root/World/Player")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func apply_movement(acceleration):
	motion += acceleration
	motion = motion.clamped(MAX_SPEED)
	
func _physics_process(delta):
	look_at(playerNode.position)
	
	var dir = playerNode.position - position
	
	apply_movement(dir * ACCEL * delta)
	
	motion = move_and_slide(motion)

func _on_Hitbox_body_entered(body):
	body.queue_free()
	queue_free()
	
func explode():
	queue_free()
