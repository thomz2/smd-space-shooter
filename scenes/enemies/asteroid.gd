extends CombatCharacter3D







func _physics_process(delta: float) -> void:
	velocity = global_basis.z * 3.0
	move_and_slide()
