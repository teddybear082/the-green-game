extends Control

var level1 = preload("res://src/vessel/vessel.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_IntroSceneBRANE_intro_scene_brane_finished():
	get_tree().change_scene("res://src/vessel/vessel.tscn")
	
