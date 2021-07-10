extends TextureButton


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var playerNode = null
var turret_cost = 5

onready var turret_label = $TurretLabel


func _ready():
	playerNode = get_node("/root/World/Player")
	
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	turret_cost = get_node("/root/World/GUI/UI/TurretBuilder").turret_cost
	if (playerNode.money >= turret_cost):
		modulate.a = 1.0
	else:
		modulate.a = 0.5
	
	turret_label.text = str(turret_cost) + " Gold"
