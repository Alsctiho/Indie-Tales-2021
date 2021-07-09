extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var portal_path

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _integrate_forces(state):
	if (state.get_contact_count() > 0) :
		var contact = state.get_contact_local_position(0)
		if (contact != Vector2.ZERO):
			get_node(portal_path).change_position(contact)
	#		print(get_viewport_rect().size.x)
			queue_free()
