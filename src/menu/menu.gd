extends Control


signal game_started
signal shadows_toggled
signal snap_turn_toggled
signal teleport_toggled
export var start_button_text := ""

# Called when the node enters the scene tree for the first time.
func _ready():
	if(start_button_text != ""):
		$VBoxContainer/StartButton.text = start_button_text
	$CreditsPanelContainer.hide()
	
	$VBoxContainer/HBoxContainer/ShadowsCheckBox.pressed = UserSettings.use_shadows
	$VBoxContainer/HBoxContainer2/SnapTurnCheckBox.pressed = UserSettings.use_snap_turn
	$VBoxContainer/HBoxContainer2/TeleportCheckBox.pressed = UserSettings.use_teleport
	
func _on_ExitButton_pressed():
	get_tree().quit()


func _on_StartButton_pressed():
	$VBoxContainer/StartButton.text = "Continue"
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	#self.hide()
	emit_signal("game_started")

func trigger():
	if(self.visible):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		self.hide()
	else:
		self.show()
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func _on_CreditsButton_pressed():
	$CreditsPanelContainer.show()


func _on_CloseCreditsButton_pressed():
	$CreditsPanelContainer.hide()


func _on_ShadowsCheckBox_toggled(button_pressed):
	emit_signal("shadows_toggled", button_pressed)




func _on_SnapTurnCheckBox_toggled(button_pressed):
	emit_signal("snap_turn_toggled", button_pressed)


func _on_TeleportCheckBox_toggled(button_pressed):
	emit_signal("teleport_toggled", button_pressed)
