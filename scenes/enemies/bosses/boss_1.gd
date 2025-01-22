extends CombatCharacter3D

var packed_blaster_bullet = preload("res://scenes/enemies/enemy_ship_bullet.tscn")
var packed_spread_bullet = preload("res://scenes/enemies/generic_bullet.tscn")

var spread_timer : float = 1.0
var blaster_timer : float = 2.0
var active_blaster_id : int = 0


@onready var player : Player = get_tree().get_first_node_in_group("PLAYER")


func _ready() -> void:
	super()
	
	
	#global position is 0,0,0 for one frame so lets wait a bit
	await get_tree().physics_frame
	#fly into screen
	var target_position = global_position + Vector3.BACK * 10
	var move_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	move_tween.tween_property(self, "global_position", target_position, 4.0)
	#tween starts on its own


func _physics_process(delta: float) -> void:
	#super(delta)
	
	blaster_timer -= delta
	if blaster_timer <= 0:
		blaster_timer += 3.2
		if active_blaster_id == 1: active_blaster_id = 0
		elif active_blaster_id == 0: active_blaster_id = 1
		shoot_blasters()
	
	spread_timer -= delta
	if spread_timer <= 0:
		spread_timer += 4.1
		shoot_spread()


func shoot_blasters() -> void:
	var current_blaster : Marker3D = $BlasterMarkers.get_child(active_blaster_id)
	
	for i in range(6):
		var vector_to_player = (player.global_position - current_blaster.global_position).normalized()
		for d in range(2):
			var bullet : Bullet3D = packed_blaster_bullet.instantiate()
			get_tree().current_scene.add_child(bullet)
			bullet.global_position = current_blaster.global_position
			bullet.set_global_forwards(vector_to_player)
			var angle = deg_to_rad(10)
			if d == 0: bullet.rotate_x(angle)
			else: bullet.rotate_x(-angle)
		await get_tree().create_timer(0.2).timeout


func shoot_spread() -> void:
	var spread_position = $SpreadMarker.global_position
	
	for i in range(16):
		var bullet : Bullet3D = packed_spread_bullet.instantiate()
		get_tree().current_scene.add_child(bullet)
		bullet.global_position = spread_position
		bullet.set_global_forwards(Vector3.BACK)
		
		var angle = deg_to_rad(5) * i
		if i%2 == 0: angle *= -1
		bullet.rotate_x(angle)
		await get_tree().create_timer(0.05).timeout
