extends CombatCharacter3D



@export var packed_bullet : PackedScene = preload("res://scenes/enemies/generic_bullet.tscn")

var shoot_angle_degrees : float = 0.0


func _ready() -> void:
	super()
	$ShootTimer.timeout.connect(self.shoot)


func _physics_process(_delta: float) -> void:
	velocity = -global_basis.z * 9
	velocity.y += sin(4 * Time.get_ticks_msec()/1000.0) * 3
	move_and_slide()


func shoot():
	var bullet : Bullet3D = packed_bullet.instantiate()
	bullet.initial_speed = 5
	get_tree().current_scene.add_child(bullet)
	bullet.global_position = self.global_position
	bullet.global_rotation = self.global_rotation
	bullet.rotate_x(deg_to_rad(shoot_angle_degrees))
	AudioManager.play_sfx("enemy_shot_tiny.wav")
	shoot_angle_degrees += 30
	
