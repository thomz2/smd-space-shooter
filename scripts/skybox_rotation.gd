extends WorldEnvironment

@export var rotation_speed: float = 0.005

func _process(delta: float) -> void:
	# Obtém a rotação atual do céu
	var current_rotation = environment.sky_rotation

	# Incrementa a rotação lentamente com base na velocidade e no delta
	current_rotation.y += rotation_speed * delta
	current_rotation.x += (rotation_speed / 3) * delta

	# Atualiza a rotação do céu
	environment.sky_rotation = current_rotation
