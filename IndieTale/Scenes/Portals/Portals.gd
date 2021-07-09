extends Area2D

enum PORTAL_TYPE {
	In,
	Out
}

export(PORTAL_TYPE) var type = PORTAL_TYPE.In
export (NodePath) var otherPortalPath

var bullet_scene = preload("res://Scenes/Bullets/Bullets.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	
#	print(get_node(otherPortalPath).rotation_degrees)
	
	match type:
		PORTAL_TYPE.In:
			$Sprite.modulate.r = 0
			$Sprite.modulate.g = 0
		PORTAL_TYPE.Out:
			$Sprite.modulate.b = 0
			$Sprite.modulate.g = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Portals_body_entered(body):
#	print(body)
	
	if (body.creator != self):
		get_node(otherPortalPath).fire(body.linear_velocity.length(), body.rotation)
		body.queue_free()
	

func fire(vel, rot):
	var bullet_instance = bullet_scene.instance()
	bullet_instance.position = position + Vector2(0, 10)
	
	var new_rot = rot + PI + (rotation - get_node(otherPortalPath).rotation)
	
	bullet_instance.rotation = new_rot
	bullet_instance.apply_impulse(Vector2.ZERO, Vector2(vel, 0).rotated(new_rot))
	bullet_instance.creator = self
	get_parent().add_child(bullet_instance)
	
