extends Spatial


export(NodePath) var cam_path := NodePath("Camera")
onready var cam: Camera = get_node(cam_path)

export var mouse_sensitivity := 2.0
export var y_limit := 90.0
var mouse_axis := Vector2()
var rot := Vector3()
var _is_locked := false
var initial_y_rotation := 0;

onready var _raycast = get_node("Camera/RayCast")
var _lastCollidingObject

signal trash_picked_up
signal game_finished

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mouse_sensitivity = mouse_sensitivity / 1000
	y_limit = deg2rad(y_limit)
	var tween = get_tree().create_tween()
	tween.tween_callback(self, "hide_shader_cache").set_delay(5)
	initial_y_rotation = get_owner().rotation.y

#needed for VR version since there is no input event, always need to be checking raycast colliders
func _process(delta):
	if(_is_locked):
		return
	check_colliders()
	
# Called when there is an input event
func _input(event: InputEvent) -> void:
	if(_is_locked):
		return
	# Mouse look (only if the mouse is captured).
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		mouse_axis = event.relative
		camera_rotation()
		check_colliders()

func camera_rotation() -> void:
	# Horizontal mouse look.
	rot.y -= mouse_axis.x * mouse_sensitivity
	# Vertical mouse look.
	rot.x = clamp(rot.x - mouse_axis.y * mouse_sensitivity, -y_limit, y_limit)
	get_owner().rotation.y = rot.y + initial_y_rotation
	rotation.x = rot.x


func check_colliders():
	var collider = _raycast.get_collider()
	if collider && _lastCollidingObject != collider:
		if(_lastCollidingObject && weakref(_lastCollidingObject).get_ref()):
			_lastCollidingObject.get_owner().change_outline_visibility(false)
		_lastCollidingObject = collider
		_lastCollidingObject.get_owner().change_outline_visibility(true)
	if !collider && _lastCollidingObject && weakref(_lastCollidingObject).get_ref():
		_lastCollidingObject.get_owner().change_outline_visibility(false)
		_lastCollidingObject = null
		
func grab():
	if(_lastCollidingObject && weakref(_lastCollidingObject).get_ref() && _lastCollidingObject.get_owner().get_is_highlighted()):
		if(_lastCollidingObject.get_owner().name == "Handle"):
			if(!_lastCollidingObject.get_owner().is_turned):
				_lastCollidingObject.get_owner().start_grabbing_animation($grabber.global_transform)
				$grabber.hide()
				_is_locked = true
		elif(_lastCollidingObject.get_owner().name == 'liana'):
			$AnimationPlayer.play("grab_final")
			$grabber.make_green()
			emit_signal("game_finished")
			_is_locked = true
		else:
			$AnimationPlayer.play("grab_vertical")
			emit_signal("trash_picked_up")
	else:
		$AnimationPlayer.play("empty_grab")


func position_object_inside_grabber():
	if(_lastCollidingObject  && weakref(_lastCollidingObject).get_ref() &&  _lastCollidingObject.get_owner().get_is_highlighted()):
		var collidingObject = _lastCollidingObject.get_owner()
		$grabber.grab(collidingObject)

func throw_object():
	if($grabber.has_grabbed_object()):
		$ThrowAudioStreamPlayer3D.play()
		$grabber.throw($garbage_bag/Position3D.global_translation)

func unlock():
	_is_locked = false
	$grabber.show()

func hide_shader_cache():
	$Camera/ShaderCache.hide()

func introduce_grabber():
	$AnimationPlayer.play("introduce_grabber")

func add_garbage_bag():
	var garbage_bag_scene = load("res://src/garbage_bag/garbage_bag.tscn")
	var garbage_bag = garbage_bag_scene.instance()

	garbage_bag.translation = Vector3(-3.5,-1.7,-2.2)
	garbage_bag.rotation_degrees = Vector3(-30,-91, 0)
	garbage_bag.scale = Vector3(1,1,1)
	self.add_child(garbage_bag)
	get_parent().get_node("FPController/LeftHandController/garbage_bag_RemoteTransform").remote_path = garbage_bag.get_path()
