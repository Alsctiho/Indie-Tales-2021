extends TextureProgress

var max_health = 10.0

onready var player = get_node("/root/World/Player")

func _process(_delta):
	self.value = player.health / max_health * 100.0
