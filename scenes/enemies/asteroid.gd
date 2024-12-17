extends CombatCharacter3D

@export var min_size: float = 1.5
@export var max_size: float = 3.0

@onready var model : Node3D = $Model

func _ready() -> void:
	super()
	change_to_random_size()

func _physics_process(delta: float) -> void:
	velocity = -global_basis.z * 1.1
	model.rotate_x(deg_to_rad(180) * delta)
	move_and_slide()

func change_to_random_size() -> void:
	var random_size = randf_range(min_size, max_size)
	scale = Vector3(random_size, random_size, random_size)
