extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	yield(get_tree().create_timer(2.0), "timeout")
	$CreditsViewport2Din3D.get_scene_instance().roll_credits()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
