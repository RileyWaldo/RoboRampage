extends Area3D

@export var ammoType: AmmoHandler.ammoType
@export var amount: int = 20


func _on_body_entered(body: Node3D) -> void:
	if(body.is_in_group("player")):
		body.ammoHandler.AddAmmo(ammoType, amount)
		queue_free()
