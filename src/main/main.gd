extends Spatial

#-----------------SCENE--SCRIPT------------------#
#    Close your game faster by clicking 'Esc'    #
#   Change mouse mode by clicking 'Shift + F1'   #
#------------------------------------------------#

export var level_name := ""

var initial_trash_count = 0.0
var trash_picked_up = 0.0
var is_game_started = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if(level_name != 'vessel'):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		$MainMenuViewport3D.get_scene_instance().get_node("VBoxContainer/StartButton").text = "Continue"
	call_deferred('setup_level')
	
	#Connect necessary signals
	$MainMenuViewport3D.get_scene_instance().connect("game_started", self, "_on_MainMenu_game_started")
	$MainMenuViewport3D.get_scene_instance().connect("shadows_toggled", self, "_on_MainMenu_shadows_toggled")
	$Player/Head.connect("game_finished", self, "_on_Head_game_finished")
	$Player/Head.connect("trash_picked_up", self, "_on_Head_trash_picked_up")
	$Player/FPController/LeftHandController.connect("button_pressed", self, "_on_left_controller_button_pressed")

	
# Needed for VR since VR does not create input events to generate main menu popup
func _on_left_controller_button_pressed(button):
	if button != JOY_OCULUS_BY:
		return
		
	if button == JOY_OCULUS_BY:
		if $MainMenuViewport3D.visible == false:
			$MainMenuViewport3D.global_transform = $Player/FPController/ARVRCamera.global_transform
			$MainMenuViewport3D.translate_object_local(Vector3(0,0,-3))
			$MainMenuViewport3D.visible = true
			$MainMenuViewport3D.enabled = true
			$Player/FPController/LeftHandController/FunctionPointer.enabled = true
		else:
			$MainMenuViewport3D.visible = false
			$MainMenuViewport3D.enabled = false
			$Player/FPController/LeftHandController/FunctionPointer.enabled = false

#func _input(event: InputEvent) -> void:
#	if event.is_action_pressed("ui_cancel"):
#		$MainMenu.trigger()


func _on_FloorDoor_floor_door_opened():
	var transform = Transform()
	var tween = get_tree().create_tween()
	tween.tween_property($Player/FPController, "transform", Transform($Player/FPController.transform.basis, Vector3(-0.25, -0.4, 22.3)), 0.5)
	$AnimationPlayer.play("teleport_player")
	$Player.disable_movement()

func change_scene():
	get_tree().change_scene("res://src/main/main.tscn")

func setup_level():
	if(level_name == "vessel"):
		$Player.hide_grabber_and_disable_movement()
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	elif(level_name == "test"):
		pass
	else:
		initial_trash_count = $TrashScatter3D.get_child_count()
		for child in $TrashScatter3D.get_children():
			child.global_scale(Vector3(.5,.5,.5))
		$Player/Head.add_garbage_bag()

func _on_MainMenu_game_started():
	if(level_name == "vessel" && !is_game_started):
		$MainMenuViewport3D.enabled = false
		$MainMenuViewport3D.visible = false
		$AnimationPlayer.play("start_doors")
		$StartingDoors/AudioStreamPlayer3D.play()
		is_game_started = true
		$Player.show_grabber_and_enable_movement()
		yield(get_tree().create_timer(2.0), "timeout")
		$Occluders/TreeOccluder.visible = true
	else:
		$MainMenuViewport3D.enabled = false
		$MainMenuViewport3D.visible = false
		$Player/FPController/LeftHandController/FunctionPointer.enabled = false
		
func _on_Head_trash_picked_up():
	trash_picked_up += 1
	var trash_picked_up_percentage = trash_picked_up / initial_trash_count * 100.0
	prints("picked up ", trash_picked_up_percentage, "%")
	$TreeOfLife.lifeness = trash_picked_up_percentage


func _on_Head_game_finished():
	$WorldEnvironment.finish_game()

func _on_MainMenu_shadows_toggled(toggle):
	if get_node_or_null("WorldEnvironment/DirectionalLight") != null:
		$WorldEnvironment/DirectionalLight.shadow_enabled = toggle
