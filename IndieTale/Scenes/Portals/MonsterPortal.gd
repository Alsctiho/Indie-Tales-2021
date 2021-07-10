extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const APPEAR_TIME = 0.5


export (PackedScene) var monster_scene = preload("res://Scenes/Monsters/Monsters.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	z_index = 0
	scale = Vector2.ZERO

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	scale = scale.move_toward(Vector2.ONE, 1 / APPEAR_TIME * delta)

func _on_Timer_timeout():
	var monster = monster_scene.instance()
	monster.position = position
	monster.rotation = rotation
	get_parent().get_node("MonstersParent").call_deferred("add_child", monster)
