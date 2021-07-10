extends TextureButton


var health_cost = 1
var player = null
var is_affordable = true

onready var health_label = $HealthLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	player = get_node("/root/World/Player")
	if (player.money >= health_cost):
		modulate.a = 1.0
		is_affordable = true
	else:
		modulate.a = 0.5
		is_affordable = false
	
	health_label.text = str(health_cost) + " Gold"


func _on_HealthButton_pressed():
	if is_affordable:
		get_node("/root/World/Player").gain_health(1, health_cost)
		health_cost *= 10
