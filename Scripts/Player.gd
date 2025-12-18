extends CharacterBody3D
class_name Player

@export var maxHealth := 100
@export var moveSpeed := 5.0
##How high the player can jump in meters
@export var jumpHeight := 1.0
@export var fallMultiplyer := 2.0
@export var aimMultiplyer := 0.4
@export var zoomSpeed := 20.0

var health: int = maxHealth:
	set(value):
		if(value < health):
			damageOverlay.stop(false)
			damageOverlay.play("TakeDamage")
		health = value
		if(health <= 0):
			Die()
var mouseMotion: Vector2 = Vector2.ZERO

@onready var cameraPivot: Node3D = $CameraPivot
@onready var damageOverlay: AnimationPlayer = $DamageOverlay/AnimationPlayer
@onready var gameOverMenu: Control = $GameOverMenu
@onready var ammoHandler: AmmoHandler = %AmmoHandler
@onready var smoothCamera: Camera3D = %SmoothCamera
@onready var weaponCamera: Camera3D = %WeaponCamera

@onready var smoothCameraFOV := smoothCamera.fov
@onready var weaponCameraFOV := weaponCamera.fov

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
func _process(delta: float) -> void:
	if(Input.is_action_pressed("aim")):
		smoothCamera.fov = lerp(smoothCamera.fov, smoothCameraFOV * aimMultiplyer, delta * zoomSpeed)
		weaponCamera.fov = lerp(weaponCamera.fov, weaponCameraFOV * aimMultiplyer, delta * zoomSpeed)
	else:
		smoothCamera.fov = lerp(smoothCamera.fov, smoothCameraFOV, delta * zoomSpeed)
		weaponCamera.fov = lerp(weaponCamera.fov, weaponCameraFOV, delta * zoomSpeed)

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
		if(Input.is_action_pressed("aim")):
			velocity.x *= aimMultiplyer
			velocity.z *= aimMultiplyer
	else:
		velocity.x = move_toward(velocity.x, 0, moveSpeed)
		velocity.z = move_toward(velocity.z, 0, moveSpeed)

	move_and_slide()

func _input(event: InputEvent) -> void:
	if(event is InputEventMouseMotion):
		if(Input.mouse_mode == Input.MOUSE_MODE_CAPTURED):
			mouseMotion = -event.relative * 0.001
			if(Input.is_action_pressed("aim")):
				mouseMotion *= aimMultiplyer
	
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

func Die() -> void:
	gameOverMenu.GameOver()
