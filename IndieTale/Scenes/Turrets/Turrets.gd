extends Node2D


enum {
	Nothing,
	Blue,
	Red,
	Yellow,
}

var turret_type_names = ["res://Assets/Turrets/TurretTest.png", "res://Assets/Turrets/Turret.png"]

# Return true if building success, return false if it fails
# rot should be radius
func build_turret(pos: Vector2, rot: float, turret_type) -> void:
	print(pos, rot)
	var turret_scene = load("res://Scenes/Turrets/Turret.tscn")
	var turret_instance = turret_scene.instance()
	self.add_child(turret_instance)
	turret_instance.get_node("TurretSprite").texture = load(turret_type_names[turret_type])
	turret_instance.position = pos
	turret_instance.rotation = rot

