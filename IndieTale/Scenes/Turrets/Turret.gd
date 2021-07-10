extends Node2D


var bullet_scene = preload("res://Scenes/Bullets/Bullets.tscn")

var timer

var is_fire_ready = false
var fire_delay = 0.2

func _ready():
	timer = Timer.new()
	timer.connect("timeout",self,"_on_timer_timeout")
	timer.wait_time = fire_delay
	self.add_child(timer)
	timer.start()
	
	z_index = 20

func _on_timer_timeout() -> void:
	var bullet_instance = bullet_scene.instance()
	bullet_instance.position = position
	bullet_instance.rotation = rotation - PI/2
	bullet_instance.apply_impulse(Vector2.ZERO, Vector2(bullet_instance.bullet_speed, 0).rotated(rotation - PI/2))
	get_node("/root/World").add_child(bullet_instance)
	
	if !$AudioStreamPlayer2D.is_playing():
		$AudioStreamPlayer2D.volume_db = -1 * get_parent().get_child_count()
		$AudioStreamPlayer2D.play()
	
