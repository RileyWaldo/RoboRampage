extends CharacterBody3D


@export var moveSpeed = 5.0
##How high the player can jump in meters
@export var jumpHeight = 1.0
@export var fallMultiplyer: float = 2.0

var mouseMotion: Vector2 = Vector2.ZERO

@onready var cameraPivot: Node3D = $CameraPivot


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta: float) -> void:
	HandleCameraRotation()
	
	var isOnFloor: bool = is_on_floor()
	# Add the gravity.
	if(!isOnFloor):
		if(velocity.y >= 0):
			velocity += get_gravity() * delta
		else:
			velocity += get_gravity() * delta * fallMultiplyer

	# Handle jump.
	if(Input.is_action_just_pressed("jump") and isOnFloor):
		velocity.y = sqrt(jumpHeight * 2.0 * -get_gravity().y)

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
			
	if(event is InputEventMouseButton):
		if(event.pressed and event.button_index == MOUSE_BUTTON_LEFT):
			if(Input.mouse_mode == Input.MOUSE_MODE_VISIBLE):
				Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	if(event.is_action_pressed("ui_cancel")):
		if(Input.mouse_mode == Input.MOUSE_MODE_CAPTURED):
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			get_tree().quit()
		
func HandleCameraRotation() -> void:
	rotate_y(mouseMotion.x)
	cameraPivot.rotate_x(mouseMotion.y)
	cameraPivot.rotation_degrees.x = clampf(cameraPivot.rotation_degrees.x, -90.0, 90.0)
	mouseMotion = Vector2.ZERO
