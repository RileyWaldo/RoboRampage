extends Node3D

@export var weapon: Array[Node3D]

func _ready() -> void:
	Equip(weapon[0])

func Equip(activeWeapon: Node3D) -> void:
	for child: Node3D in get_children():
		if(child == activeWeapon):
			child.visible = true
			child.set_process(true)
		else:
			child.visible = false
			child.set_process(false)

func _unhandled_input(event: InputEvent) -> void:
	if(event.is_action_pressed("weapon1")):
		Equip(weapon[0])
	
	if(event.is_action_pressed("weapon2")):
		Equip(weapon[1])
