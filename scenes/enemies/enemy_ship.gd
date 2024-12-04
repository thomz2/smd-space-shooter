extends CombatCharacter3D



@export var packed_bullet : PackedScene = preload("res://scenes/enemies/enemy_ship_bullet.tscn")



func _ready() -> void:
	pass
	#super()
	$ShootTimer.timeout.connect(self.shoot)


func shoot():
	var bullet : Bullet3D = packed_bullet.instantiate()
	get_tree().current_scene.add_child(bullet)
	bullet.global_position = self.global_position
	bullet.global_rotation = self.global_rotation
