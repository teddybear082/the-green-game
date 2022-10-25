extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	yield(get_tree().create_timer(1.0), "timeout")
	$CreditsViewport2Din3D.enabled = false
	$CreditsViewport2Din3D.visible = false
	$CreditsViewport2Din3D.global_transform = $FPController/ARVRCamera.global_transform
	$CreditsViewport2Din3D.translate_object_local(Vector3(0,0,-3))
	yield(get_tree().create_timer(1.0), "timeout")
	$CreditsViewport2Din3D.enabled = true
	$CreditsViewport2Din3D.visible = true
	$CreditsViewport2Din3D.get_scene_instance().roll_credits()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
