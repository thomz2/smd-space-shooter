extends PlayerShotComponent

@export var cone_angle_degrees := 30.0



func shoot() -> void:
	for i in range(2):
		if not packed_bullet: printerr("No bullet to shoot!")
		var bullet : Bullet3D = packed_bullet.instantiate()
		get_tree().current_scene.add_child(bullet)
		
		# place at this node's center
		# TODO: place at shooting spot? use this node as a scene if we need multiple spots? hard code position offsets?
		bullet.global_position = self.global_position
		# rotate to face parent's facing, as well as extra 30°
		bullet.set_global_forwards((-parent.global_basis.z).normalized())
		if i == 0:
			bullet.rotate_x(deg_to_rad(cone_angle_degrees/2))
		elif i == 1:
			bullet.rotate_x(deg_to_rad(-cone_angle_degrees/2))
		
		AudioManager.play_sfx("player_shot_1.wav")
