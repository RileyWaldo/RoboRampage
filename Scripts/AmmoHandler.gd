extends Node
class_name AmmoHandler

enum ammoType {
	BULLET,
	SMALL_BULLET
}

@export var ammoLabel: Label

var ammoStorage := {
	ammoType.BULLET: 10,
	ammoType.SMALL_BULLET: 60
}


func HasAmmo(type: ammoType) -> bool:
	return ammoStorage[type] > 0
	
func UseAmmo(type: ammoType) -> void:
	if(HasAmmo(type)):
		ammoStorage[type] -= 1
		UpdateAmmoLabel(type)
		
func AddAmmo(type: ammoType, amount: int) -> void:
	ammoStorage[type] += amount
	UpdateAmmoLabel(type)

func UpdateAmmoLabel(type: ammoType) -> void:
	ammoLabel.text = str(ammoStorage[type])
