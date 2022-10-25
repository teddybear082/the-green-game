extends Spatial
class_name Thrash

export(NodePath) var mesh_to_outline_path
var _mesh_to_outline: MeshInstance

var _is_highlighted := false
var _damp = 50

func _ready():
	_set_random_color()
	_set_mesh_to_outline()
	get_node("RigidBody").linear_damp = _damp
	add_to_group("trash")


func change_outline_visibility(is_visible: bool):
	if(is_visible):
		_is_highlighted = true
		_mesh_to_outline.get_active_material(0).next_pass.set("shader_param/outline_width", 2)
	else:
		_is_highlighted = false
		_mesh_to_outline.get_active_material(0).next_pass.set("shader_param/outline_width", 0)

func _set_random_color():
	var colorChanger = get_node_or_null("ColorChanger")
	if(colorChanger != null):
		colorChanger.change_color()

func _set_mesh_to_outline():
	assert(!mesh_to_outline_path.is_empty())
	_mesh_to_outline = get_node(mesh_to_outline_path)
	_mesh_to_outline.set_surface_material(0, _mesh_to_outline.get_active_material(0).duplicate())
	var outline_shader = load("res://materials/outline_shadermaterial.tres").duplicate()
	outline_shader.set("shader_param/outline_width", 0)
	_mesh_to_outline.get_active_material(0).set_next_pass(outline_shader)


func get_is_highlighted():
	return _is_highlighted
