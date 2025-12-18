extends Node
class_name AmmoHandler

enum ammoType {
	BULLET,
	SMALL_BULLET
}

var ammoStorage := {
	ammoType.BULLET: 10,
	ammoType.SMALL_BULLET: 60
}

func HasAmmo(type: ammoType) -> bool:
	return ammoStorage[type] > 0
	
func UseAmmo(type: ammoType) -> void:
	if(HasAmmo(type)):
		ammoStorage[type] -= 1
