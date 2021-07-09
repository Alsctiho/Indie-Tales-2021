extends Node2D


enum {
	Nothing,
	Blue,
	Red,
	Yellow,
}

var state = Nothing
var building_phase = 0
var turret_instance = null

const turret_node_path = "res://Scenes/Turrets/Turret.tscn"
const texture_path = ["res://Assets/Turrets/TurretTest.png", "res://Assets/Turrets/Turret.png"]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(_delta):		
	if state != Nothing:
		building_turret()

func get_mouse_rotation() -> float:
	var normalized_vector = (get_global_mouse_position() - turret_instance.position).normalized()
#	print(normalized_vector.cross(Vector2.UP))
	if normalized_vector.y < 0:
		return asin(Vector2.UP.cross(normalized_vector))
	else:
		return PI - asin(Vector2.UP.cross(normalized_vector))

func building_turret() -> void:
	# The first phase: position
	if building_phase == 0:
		turret_instance.position = get_global_mouse_position()
		if Input.is_action_just_pressed("ui_left_click"):
#			print("left click")
			building_phase += 1

	# The second phase: rotation
	elif building_phase == 1:
		turret_instance.rotation = get_mouse_rotation()
		if Input.is_action_just_pressed("ui_left_click"):
#			print("left click", turret_instance.rotation)
			building_phase += 1

	# The third phase: building
	elif building_phase == 2:
		self.remove_child(turret_instance)
		print(get_node("/root/World/Turrets"))
		get_node("/root/World/Turrets").add_child(turret_instance)
		
		# if building success, doing clean up
		turret_instance = null
		building_phase = 0
		state = Nothing

func instance_turret() -> void:
	turret_instance = load(turret_node_path).instance()
	turret_instance.get_node("TurretSprite").texture = load(texture_path[state])
	self.add_child(turret_instance)

func _on_TurretBlue_pressed() -> void:
	state = Blue
	print("pressed!")
	instance_turret()
