extends Spatial

export var gravity_multiplier := 3.0
export var speed := 3.5
export var acceleration := 6
export var deceleration := 8
export(float, 0.0, 1.0, 0.05) var air_control := 0.3
export var jump_height := 5
var direction := Vector3()
var input_axis := Vector2()
var velocity := Vector3()
var snap := Vector3()
var up_direction := Vector3.UP
var stop_on_slope := true
var _is_locked := false
onready var floor_max_angle: float = deg2rad(45.0)
# Get the gravity from the project settings to be synced with RigidDynamicBody nodes.
onready var gravity = (ProjectSettings.get_setting("physics/3d/default_gravity") 
		* gravity_multiplier)
var _movement_disabled := false


# Called when the node enters the scene tree for the first time.

func _ready():
	add_to_group("player")
	call_deferred('connect_to_handle_signals')
	$FPController/RightHandController.connect("button_pressed", self, "_on_right_controller_button_pressed")
	$FPController/LeftHandController.connect("button_pressed", self, "_on_left_controller_button_pressed")
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


# Called every physics tick. 'delta' is constant
func _physics_process(delta) -> void:
	pass
	
	
func connect_to_handle_signals():
	var handles = get_tree().get_nodes_in_group("handle")
	for handle in handles:
		handle.connect("turn_finished", self, "_on_Handle_turn_finished")
		
func _on_Handle_turn_finished():
	_is_locked = false
	$Head.unlock()
			
func disable_movement():
	_movement_disabled = true
	$CollisionShape.disabled = true
	$Head/grabber.hide()
	if($Head/garbage_bag):
		$Head/garbage_bag.hide()

func hide_grabber_and_disable_movement():
	_movement_disabled = true
	if($Head/garbage_bag):
		$Head/garbage_bag.hide()
	$Head/grabber.hide()

func show_grabber_and_enable_movement():
	_movement_disabled = false
#	$Head/garbage_bag.show()
	$Head.introduce_grabber()
	
func display_garbage_bag():
	pass
	
func _on_right_controller_button_pressed(button):
	if button == JOY_VR_TRIGGER:
		if(Input.mouse_mode == Input.MOUSE_MODE_CAPTURED):
			$Head.grab()
		
func _on_left_controller_button_pressed(button):
	pass
