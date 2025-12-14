extends CharacterBody3D


@export var moveSpeed = 5.0
@export var jumpVelocity = 4.5

var mouseMotion: Vector2 = Vector2.ZERO

@onready var cameraPivot: Node3D = $CameraPivot


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta: float) -> void:
	HandleCameraRotation()
	
	var isOnFloor: bool = is_on_floor()
	# Add the gravity.
	if(!isOnFloor):
		velocity += get_gravity() * delta

	# Handle jump.
	if(Input.is_action_just_pressed("jump") and isOnFloor):
		velocity.y = jumpVelocity

	# Get the input direction and handle the movement/deceleration.
	var inputVector := Input.get_vector("moveLeft", "moveRight", "moveForward", "moveBack")
	var direction := (transform.basis * Vector3(inputVector.x, 0, inputVector.y)).normalized()
	if(direction):
		velocity.x = direction.x * moveSpeed
		velocity.z = direction.z * moveSpeed
	else:
		velocity.x = move_toward(velocity.x, 0, moveSpeed)
		velocity.z = move_toward(velocity.z, 0, moveSpeed)

	move_and_slide()

func _input(event: InputEvent) -> void:
	if(event is InputEventMouseMotion):
		if(Input.mouse_mode == Input.MOUSE_MODE_CAPTURED):
			mouseMotion = -event.relative * 0.001
	
	if(event.is_action_pressed("ui_cancel")):
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		
func HandleCameraRotation() -> void:
	rotate_y(mouseMotion.x)
	cameraPivot.rotate_x(mouseMotion.y)
	cameraPivot.rotation_degrees.x = clampf(cameraPivot.rotation_degrees.x, -90.0, 90.0)
	mouseMotion = Vector2.ZERO
