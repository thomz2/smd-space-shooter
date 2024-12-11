extends CombatCharacter3D

@export var min_size: float = 0.5
@export var max_size: float = 2.0

func _physics_process(delta: float) -> void:
	velocity = global_basis.z * 3.0
	move_and_slide()

func change_to_random_size() -> void:
	var random_size = randf_range(min_size, max_size)
	scale = Vector3(random_size, random_size, random_size)
