extends RigidBody2D
#
#const FRICTION = 0.8
#
var bullet_speed = 2000
const MIN_SPEED = 0.9
#
var started_moving
var creator
#
# Called when the node enters the scene tree for the first time.
func _ready():
	z_index = 10
	get_node("VisibilityNotifier2D").connect("screen_exited", self, "_on_screen_exited")

func _on_screen_exited():
	queue_free()

#func _physics_process(delta):
#	var friction_force = -linear_velocity * FRICTION * delta
##	print(friction_force)
#	apply_impulse(Vector2.ZERO, friction_force)
##	print(linear_velocity)
#
func _process(delta):
	if linear_velocity.length() > MIN_SPEED:
		started_moving = true
	if started_moving:
		$Sprite.modulate.a = clamp(linear_velocity.length() / 4 - 2, 0 , 1)
	if started_moving and (linear_velocity.length() + angular_velocity) < MIN_SPEED:
		queue_free()
