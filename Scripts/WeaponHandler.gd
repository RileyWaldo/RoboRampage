extends Node3D

var weapons: Array[Node3D]
var weaponIndex: int = 0
var nextWeapon: Node3D
var isSwappingWeapons: bool = false

@onready var weaponWrapAnimator: AnimationPlayer = %WeaponSwapAnimator

func _ready() -> void:
	for child in get_children():
		if(child is HitScan):
			weapons.append(child)
	Equip(weapons[0])
	
func SwapWeapon(weap: Node3D) -> void:
	nextWeapon = weap
	isSwappingWeapons = true
	weaponWrapAnimator.play("SwapWeapon")
	UpdateAmmoLabel(nextWeapon)
	for child: Node3D in get_children():
		child.set_process(false)
	
func SwapWeaponAnimationTrigger() -> void:
	for child: Node3D in get_children():
		if(child == nextWeapon):
			child.visible = true
		else:
			child.visible = false
	
func SwapWeaponAnimationEnd() -> void:
	isSwappingWeapons = false
	for child: Node3D in get_children():
		if(child == nextWeapon):
			child.set_process(true)
		else:
			child.set_process(false)

func Equip(activeWeapon: Node3D) -> void:
	UpdateAmmoLabel(activeWeapon)
	for child: Node3D in get_children():
		if(child == activeWeapon):
			child.visible = true
			child.set_process(true)
		else:
			child.visible = false
			child.set_process(false)
			

func CycleWeapon(cycle: int) -> void:
	weaponIndex = wrapi(weaponIndex + cycle, 0, weapons.size())
	SwapWeapon(weapons[weaponIndex])
	
func UpdateAmmoLabel(weap: HitScan) -> void:
	weap.ammoHandler.UpdateAmmoLabel(weap.ammoType)

func _unhandled_input(event: InputEvent) -> void:
	if(isSwappingWeapons):
		return
		
	if(event.is_action_pressed("weapon1")):
		if(weaponIndex != 0):
			weaponIndex = 0
			SwapWeapon(weapons[weaponIndex])
	
	if(event.is_action_pressed("weapon2")):
		if(weaponIndex != 1):
			weaponIndex = 1
			SwapWeapon(weapons[weaponIndex])
		
	if(event.is_action_pressed("nextWeapon")):
		CycleWeapon(1)
		
	if(event.is_action_pressed("previousWeapon")):
		CycleWeapon(-1)
