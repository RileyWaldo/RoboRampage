extends Node3D

@export var fireRate := 14.0
@export var recoil := 0.05
@export var recoilSpeed := 10.0
@export var weaponMesh: Node3D

@onready var rayCast: RayCast3D = $RayCast3D
@onready var cooldownTimer: Timer = $CooldownTimer
@onready var weaponStartPosition: Vector3 = weaponMesh.position

func _process(delta: float) -> void:
	Shoot()
	
	weaponMesh.position = weaponMesh.position.lerp(weaponStartPosition, delta * recoilSpeed)
	
func Shoot() -> void:
	if(!Input.is_action_pressed("fire")):
		return
	if(!cooldownTimer.is_stopped()):
		return
		
	cooldownTimer.start(1.0 / fireRate)
	weaponMesh.position.z += recoil
	print(rayCast.get_collider())
