extends CharacterBody3D
class_name Enemy

@export var maxHealth := 100
@export var moveSpeed := 5.0
@export var attackRange := 1.5
@export var damage := 20

@onready var navigationAgent: NavigationAgent3D = $NavigationAgent3D
@onready var animationTree: AnimationTree = $AnimationTree
@onready var playBack: AnimationNodeStateMachinePlayback = animationTree["parameters/playback"]

var health: int = maxHealth:
	set(value):
		health = value
		provoked = true
		if(health <= 0):
			Die()

var player: Player
var provoked := false
var aggroRange := 12.0

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	
func _process(_delta: float) -> void:
	if(!provoked and IsPlayerInRange(aggroRange)):
		provoked = true
	if(provoked):
		navigationAgent.target_position = player.global_position
		if(IsPlayerInRange(attackRange)):
			playBack.travel("Attack")

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	var nextPosition := navigationAgent.get_next_path_position()
	var direction := global_position.direction_to(nextPosition)
	if(direction):
		LookAtTarget(direction)
		velocity.x = direction.x * moveSpeed
		velocity.z = direction.z * moveSpeed
	else:
		velocity.x = move_toward(velocity.x, 0, moveSpeed)
		velocity.z = move_toward(velocity.z, 0, moveSpeed)

	move_and_slide()

#called from animation player
func Attack() -> void:
	player.health -= damage
	

func LookAtTarget(direction: Vector3) -> void:
	var adjustedDirection := direction
	adjustedDirection.y = 0
	
	look_at(global_position + adjustedDirection, Vector3.UP, true)
	
func IsPlayerInRange(rangeTo: float) -> bool:
	return global_position.distance_squared_to(player.global_position) <= pow(rangeTo, 2.0)
	
func Die() -> void:
	queue_free()
