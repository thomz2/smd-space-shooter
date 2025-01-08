extends Bullet3D

func on_reflected() -> void:
	main_hitbox.damage = 50
	
	for child in $ModelOrigin.get_children():
		if child is MeshInstance3D:
			child.mesh.material = child.mesh.material.duplicate(true)
			child.mesh.material.albedo_color = Color(0, 1, 1)
