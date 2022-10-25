tool
extends WorldEnvironment


export(float, 0, 100) var lifeness = 0 setget set_life_strength, get_life_strength

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_life_strength(strength: float):
#	self.environment.glow_intensity = lifeness * 0.01
	lifeness = strength

func get_life_strength():
	return lifeness

func finish_game():
	$AnimationPlayer.play("make_green")
	get_tree().change_scene("res://src/end_credits/end_credits_scene_vr.tscn")
