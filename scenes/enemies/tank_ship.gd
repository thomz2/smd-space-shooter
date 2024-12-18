extends CombatCharacter3D



@export var packed_bullet : PackedScene = preload("res://scenes/enemies/enemy_ship_bullet.tscn")

var shoot_angle_degrees : float = 0.0
var player : CombatCharacter3D = null

func _ready() -> void:
	super()
	$ShootTimer.timeout.connect(self.shoot)
	$ChargeParticle.emitting = false


func _physics_process(_delta: float) -> void:
	velocity = -global_basis.z * 1.5
	move_and_slide()


func shoot():
	$ShootTimer.wait_time = 2.0
	$ShootTimer.start()
	
	$ChargeParticle.emitting = true
	await get_tree().create_timer(0.8).timeout
	$ChargeParticle.emitting = false
	
	player = get_tree().get_first_node_in_group("PLAYER")
	var target_position = player.global_position
	
	for a in range(3):
		var bullet : Bullet3D = packed_bullet.instantiate()
		bullet.initial_speed = 25
		get_tree().current_scene.add_child(bullet)
		bullet.global_position = $ShootOrigin.global_position
		bullet.look_at(target_position, Vector3.UP)
		await get_tree().create_timer(0.05).timeout
	
