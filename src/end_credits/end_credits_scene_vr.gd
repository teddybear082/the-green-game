extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	yield(get_tree().create_timer(1.0), "timeout")
	$ScreenHolder/CreditsViewport2Din3D.enabled = false
	$ScreenHolder/CreditsViewport2Din3D.visible = false
	#$CreditsViewport2Din3D.global_transform.origin = $FPController/ARVRCamera.global_transform.origin
	#$CreditsViewport2Din3D.global_transform.basis.z = $FPController/ARVRCamera.global_transform.basis.z
	#$CreditsViewport2Din3D.translate_object_local(Vector3(0,0,-3))
	yield(get_tree().create_timer(1.0), "timeout")
	$ScreenHolder/CreditsViewport2Din3D.enabled = true
	$ScreenHolder/CreditsViewport2Din3D.visible = true
	$ScreenHolder/CreditsViewport2Din3D.get_scene_instance().roll_credits()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
