extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export (PackedScene) var monster_scene = preload("res://Scenes/Monsters/Monsters.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	var monster = monster_scene.instance()
	monster.position = position
	monster.rotation = rotation
	get_parent().call_deferred("add_child", monster)
