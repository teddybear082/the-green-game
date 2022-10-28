extends Spatial
export (NodePath) var vrCamera_path
export var time_to_move : float = 0.5
export var distance : float = 3.0
onready var vrCamera = get_node(vrCamera_path)
var currentPosition: Vector3
var targetPosition: Vector3
var movePosition : Vector3
var moving = false
var moveTimer = 0.0

func _ready():
	var viewDir = -vrCamera.global_transform.basis.z;
	var camPos = vrCamera.global_transform.origin;
	currentPosition = camPos + viewDir * distance;
	targetPosition = currentPosition;
	movePosition = currentPosition;
	
	look_at_from_position(currentPosition, camPos, Vector3(0,1,0));
	
	pass # Replace with function body.



func _process(dt):
	var viewDir = -vrCamera.global_transform.basis.z;
	viewDir.y = 0.0;
	viewDir = viewDir.normalized();
	
	var camPos = vrCamera.global_transform.origin;

	#TODO: rotate instead of move
	targetPosition = camPos + viewDir * distance;
	var distToTarget = (targetPosition - currentPosition).length();
	if moving:
		currentPosition = currentPosition + (movePosition - currentPosition) * dt;
		if (distToTarget < 0.05):
			moving = false;

			
	if (distToTarget > 0.5):
		moveTimer += dt;
	else:
		moveTimer = 0.0;
			
	if (moveTimer > time_to_move):
		moving = true;
		movePosition = targetPosition;

	look_at_from_position(currentPosition, camPos, Vector3(0,1,0));
