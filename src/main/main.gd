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
	call_deferred('setup_level')
	$MainMenuViewport3D.get_scene_instance().connect("game_started", self, "_on_MainMenu_game_started")
	$MainMenuViewport3D.get_scene_instance().connect("shadows_toggled", self, "_on_MainMenu_shadows_toggled")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		$MainMenu.trigger()


func _on_FloorDoor_floor_door_opened():
	var transform = Transform()
	var tween = get_tree().create_tween()
	tween.tween_property($Player, "transform", Transform($Player.transform.basis, Vector3(-0.25, -0.4, 22.3)), 0.5)
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


func _on_MainMenu_game_started():
	if(level_name == "vessel" && !is_game_started):
		$AnimationPlayer.play("start_doors")
		$StartingDoors/AudioStreamPlayer3D.play()
		is_game_started = true
		$Player.show_grabber_and_enable_movement()


func _on_Head_trash_picked_up():
	trash_picked_up += 1
	var trash_picked_up_percentage = trash_picked_up / initial_trash_count * 100.0
	prints("picked up ", trash_picked_up_percentage, "%")
	$TreeOfLife.lifeness = trash_picked_up_percentage


func _on_Head_game_finished():
	$WorldEnvironment.finish_game()

func _on_MainMenu_shadows_toggled(toggle):
	$WorldEnvironment/DirectionalLight.shadow_enabled = toggle
