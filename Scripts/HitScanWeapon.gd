extends Node3D
class_name HitScan

@export var weaponDamage := 10
@export var fireRate := 14.0
@export var automatic := false
@export var recoil := 0.05
@export var recoilSpeed := 10.0
@export var ammoHandler: AmmoHandler
@export var ammoType: AmmoHandler.ammoType
@export var weaponMesh: Node3D
@export var muzzleFlash: GPUParticles3D
@export var sparks: PackedScene

@onready var rayCast: RayCast3D = $RayCast3D
@onready var cooldownTimer: Timer = $CooldownTimer
@onready var weaponStartPosition: Vector3 = weaponMesh.position

func _process(delta: float) -> void:
	Shoot()
	
	weaponMesh.position = weaponMesh.position.lerp(weaponStartPosition, delta * recoilSpeed)
	
func Shoot() -> void:
	if(automatic):
		if(!Input.is_action_pressed("fire")):
			return
	else:
		if(!Input.is_action_just_pressed("fire")):
			return
	if(!cooldownTimer.is_stopped() or !ammoHandler.HasAmmo(ammoType)):
		return
		
	ammoHandler.UseAmmo(ammoType)
	muzzleFlash.restart()
	cooldownTimer.start(1.0 / fireRate)
	weaponMesh.position.z += recoil
	var collider = rayCast.get_collider()
	if(collider):
		var spark = sparks.instantiate()
		add_child(spark)
		spark.global_position = rayCast.get_collision_point()
		if(collider is Enemy):
			collider.health -= weaponDamage;
