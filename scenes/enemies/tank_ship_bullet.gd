extends Bullet3D



func on_reflected() -> void:
	main_hitbox.damage = 40
