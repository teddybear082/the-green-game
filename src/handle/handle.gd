extends Spatial

var _is_highlighted := false
var _damp = 50
var _initial_grabber_transform: Transform
var is_turned := false

onready var Grabber = $GrabberRotationSpatial/grabber
signal turn_finished

func _ready():
	_set_mesh_to_outline()
	add_to_group("handle")

func change_outline_visibility(is_visible: bool):
	if(is_turned):
		return
	if(is_visible):
		_is_highlighted = true
		$TopPart/Handle.get_active_material(0).next_pass.set("shader_param/outline_width", 2)
	else:
		_is_highlighted = false
		$TopPart/Handle.get_active_material(0).next_pass.set("shader_param/outline_width", 0)

func _set_mesh_to_outline():
	$TopPart/Handle.set_surface_material(0, $TopPart/Handle.get_active_material(0).duplicate())
	var outline_shader = load("res://materials/outline_shadermaterial.tres").duplicate()
	outline_shader.set("shader_param/outline_width", 0)
	$TopPart/Handle.get_active_material(0).set_next_pass(outline_shader)

func get_is_highlighted():
	return _is_highlighted


func start_grabbing_animation(grabber_transform: Transform):
	if(is_turned):
		return
	Grabber.show()
	Grabber.global_transform = grabber_transform
	_initial_grabber_transform = grabber_transform
	$Tween.interpolate_property(Grabber, "translation",
		Grabber.translation, Vector3(-0.179, 0.576, -0.296), 0.6,
		Tween.TRANS_QUAD, Tween.EASE_OUT)
	$Tween.interpolate_property(Grabber, "rotation_degrees",
		Grabber.rotation_degrees, Vector3(49.85, 169.388, -119.57), 0.4,
		Tween.TRANS_QUAD, Tween.EASE_OUT)
	$Tween.start()

func _on_Tween_tween_completed(object, key):
	if(key == ":translation"): # the grabber is at the handle, now grab the handle
		$Tween.interpolate_property(Grabber, "grab_strength",
		Grabber.grab_strength, 27, 0.2,
		Tween.TRANS_QUAD, Tween.EASE_OUT)
		$Tween.start()
		$AudioStreamPlayer3D.play()
	elif(key == ":grab_strength"): # the grabber has grabbed the handle, now turn it 90 degrees
		$Tween.interpolate_property(Grabber, "translation:x",
		-0.179, -0.195, 0.6, 
		Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
		$Tween.interpolate_property(Grabber, "rotation_degrees",
			Vector3(49.85, 169.388, -119.57), Vector3(-13.203, 115.322, -144.414), 0.6,
			Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
		$Tween.interpolate_property($TopPart, "rotation_degrees:y",
		$TopPart.rotation_degrees.y,  0, 0.6,
			Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
		$Tween.start()
	elif(key == ":rotation_degrees:y"): # the turn motion has finished, go back
		$Tween.interpolate_property(Grabber, "global_transform", 
			Grabber.global_transform, _initial_grabber_transform, 
			0.4, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
		$Tween.interpolate_property(Grabber, "grab_strength", 
			Grabber.grab_strength, 1, 
			0.5, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
		$Tween.start()
	elif(key == ":global_transform"):
		$Tween.stop_all()
		if(!is_turned):
			emit_signal("turn_finished")
			Grabber.hide()
			change_outline_visibility(false)
			is_turned = true
