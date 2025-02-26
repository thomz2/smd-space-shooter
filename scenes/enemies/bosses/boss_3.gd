extends BaseBossCharacter

enum States { ENTER, SWAY, WAIT, DASH, RETURN }

var current_state : States = States.ENTER :
	set(value):
		current_state = value
		state_time = 0.0
		on_enter_state()

var state_time : float = 0.0
var blaster_time : float = 0.0
var cannon_time : float = 0.0

var origin_position : Vector3 = Vector3.ZERO

var active_blaster : int = 0 #0 for top, 1 for bottom
var active_cannon : int = 0 #0 for top, 1 for bottom

const packed_blaster_bullet := preload("res://scenes/enemies/enemy_ship_bullet.tscn")
const packed_massive_bullet := preload("res://scenes/enemies/massive_bullet.tscn")

func _ready() -> void:
	super()
	
	
	#fly into screen
	await get_tree().physics_frame
	var target_position = global_position + Vector3.BACK * 10
	var move_tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)
	move_tween.tween_property(self, "global_position", target_position, 2.0)
	#4 seconds of entry, then change states
	move_tween.tween_property(self, "current_state", States.SWAY, 0.0)


func _physics_process(dt: float) -> void:
	state_time += dt
	
	if current_state == States.SWAY:
		var new_y = move_toward(position.y, sin(1 * state_time) * 2.0, dt*40)
		var delta_y = new_y - position.y
		position.y = new_y
		
		var cannon_period = 1.5
		if health < max_health*0.5:
			cannon_period = 0.8
		cannon_time += dt
		if cannon_time >= cannon_period:
			shoot_massive_bullet()
			cannon_time = 0
		
		blaster_time += dt
		if blaster_time > 1.3:
			shoot_blasters()
			blaster_time = 0


func on_enter_state() -> void:
	pass


func shoot() -> void:
	var player = get_tree().get_first_node_in_group("PLAYER")
	if not player: return
	
	for i in range(2):
		var blaster_pos : Vector3 = $BlasterMarkers.get_child(i).global_position
		var direction : Vector3 = blaster_pos.direction_to(player.global_position)
		var final_direction = Vector3.BACK.move_toward(direction, 0.6)
		
		var bullet : Bullet3D = packed_blaster_bullet.instantiate()
		get_tree().current_scene.add_child(bullet)
		bullet.global_position = blaster_pos
		bullet.set_global_forwards(final_direction)


func shoot_massive_bullet() -> void:
	if active_cannon == 0: active_cannon = 1
	elif active_cannon == 1: active_cannon = 0
	
	var marker = $CannonMarkers.get_child(active_cannon)
	
	marker.get_child(0).emitting = true #activate particle
	await get_tree().create_timer(0.5).timeout #wait 1 sec
	marker.get_child(0).emitting = false #deactivate particle
	
	var player = get_tree().get_first_node_in_group("PLAYER")
	var bullet : Bullet3D = packed_massive_bullet.instantiate()
	get_tree().current_scene.add_child(bullet)
	bullet.global_position = marker.global_position
	bullet.set_global_forwards(marker.global_position.direction_to(player.global_position))
	AudioManager.play_sfx("enemy_shot_big.wav")


func shoot_blasters() -> void:
	if active_blaster == 0: active_blaster = 1
	elif active_blaster == 1: active_blaster = 0
	var current_blaster : Marker3D = $BlasterMarkers.get_child(active_blaster)
	var player = get_tree().get_first_node_in_group("PLAYER")
	#only gather position once
	var player_pos = player.global_position 
	var vector_to_player = (player_pos - current_blaster.global_position).normalized()
	
	var shot_repeats = 6
	if health < max_health*0.7: shot_repeats = 10
	
	for i in range(shot_repeats):
		for d in range(4):
			var bullet : Bullet3D = packed_blaster_bullet.instantiate()
			bullet.initial_speed = 20
			get_tree().current_scene.add_child(bullet)
			bullet.global_position = current_blaster.global_position
			bullet.set_global_forwards(vector_to_player)
			var angle = deg_to_rad(25)
			if d % 2 == 0: angle /= 2
			if d < 2: bullet.rotate_x(angle)
			else: bullet.rotate_x(-angle)
		AudioManager.play_sfx("enemy_shot.wav")
		await get_tree().create_timer(0.1).timeout
