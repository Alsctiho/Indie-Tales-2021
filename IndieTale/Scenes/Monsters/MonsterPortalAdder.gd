extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var win_size = Vector2()
var timer = null

const NEW_PORTAL_TIME = 10

export (PackedScene) var MonsterPortal = preload("res://Scenes/Portals/MonsterPortal.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	win_size = get_viewport_rect().size
	timer = Timer.new()
	timer.connect("timeout",self,"_on_timer_timeout")
	timer.wait_time = NEW_PORTAL_TIME
	self.add_child(timer)
	timer.start()
	
func _on_timer_timeout():
	var rand_pos = Vector2(rand_range(0, win_size.x), rand_range(0, win_size.y))
	var monster_portal = MonsterPortal.instance()
	monster_portal.position = rand_pos
	add_child(monster_portal)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
