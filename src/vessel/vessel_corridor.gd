tool
extends Spatial

var _is_player_inside := false

export var is_light_on := true setget set_light
export var has_vases := true setget set_has_vases

# Called when the node enters the scene tree for the first time.
func _ready():
	call_deferred("set_light", false)
	call_deferred("setup")

func set_has_vases(val: bool):
	has_vases = val
	if(!$sci_fi_vase):
		return
	if(val):
		$sci_fi_vase.show()
		$sci_fi_vase2.show()
	else:
		$sci_fi_vase.hide()
		$sci_fi_vase2.hide()

func set_light(val: bool):
	if(val):
		is_light_on = true
		$lamp/SpotLight.light_energy = 5
		$lamp2/SpotLight.light_energy = 5
		$TopSpotLight.light_energy = 0.1
		$AudioStreamPlayerLightOn.play()
		for child in $FluorescentMeshes.get_children():
			child.get_active_material(0).emission_energy = 3
	else:
		if(get_node("lamp")):
			$lamp/SpotLight.light_energy = 0
			$lamp2/SpotLight.light_energy = 0
			$TopSpotLight.light_energy = 0
			for child in $FluorescentMeshes.get_children():
				child.get_active_material(0).emission_energy = 0.3
		is_light_on = false


func _on_Area_body_entered(body):
	if(body.get_parent().get_parent().get_parent().name == "Player"):
		_is_player_inside = true
		set_light(true)


func _on_Area_body_exited(body):
	if(body.get_parent().get_parent().get_parent().name == "Player"):
		_is_player_inside = false
		set_light(false)

func setup():
	var material = $FluorescentMeshes/FluorescentBottomLeft.get_active_material(0).duplicate()
	for child in $FluorescentMeshes.get_children():
		child.set_surface_material(0, material)
	var tween = get_tree().create_tween()
	tween.tween_callback(self, "turn_on_audio").set_delay(2)

func turn_on_audio():
	$AudioStreamPlayerLightOn.volume_db = -16
