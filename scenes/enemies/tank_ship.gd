extends CombatCharacter3D



@export var packed_bullet : PackedScene = preload("res://scenes/enemies/enemy_ship_bullet.tscn")

var shoot_angle_degrees : float = 0.0


func _ready() -> void:
	super()
	$ShootTimer.timeout.connect(self.shoot)


func shoot():
	var bullet : Bullet3D = packed_bullet.instantiate()
	get_tree().current_scene.add_child(bullet)
	bullet.global_position = self.global_position
	bullet.global_rotation = self.global_rotation
	bullet.rotate_x(deg_to_rad(shoot_angle_degrees))
	
	shoot_angle_degrees += 30
