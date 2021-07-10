extends TextureButton


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var playerNode = null

const TURRENT_COST = 15

func _ready():
	playerNode = get_node("/root/World/Player")
	
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (playerNode.money >= TURRENT_COST):
		modulate.a = 1.0
	else:
		modulate.a = 0.5
