extends BaseBossCharacter

enum States { ENTER, SWAY, WAIT, DASH, RETURN }

var current_state : States = States.ENTER :
	set(value):
		current_state = value
		state_time = 0.0
		on_enter_state()

var state_time : float = 0.0
var shoot_timer : float = 0.0
var shot_count : int = 5

var origin_position : Vector3 = Vector3.ZERO

const DASH_DURATION := 1.0
const DASH_LENGTH := 15.0

var packed_blaster_bullet := preload("res://scenes/enemies/enemy_ship_bullet.tscn")

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
	
	match current_state:
		States.SWAY:
			var new_y = move_toward(position.y, sin(4 * state_time) * 4.0, dt*40)
			var delta_y = new_y - position.y
			position.y = new_y
			rotation.z = move_toward(rotation.z, deg_to_rad(delta_y * 50), dt)
			
			if state_time >= 2*PI:
				current_state = States.WAIT
				position.y = 0
			
			shoot_timer += dt
			if shot_count > 0:
				if shoot_timer > 0.2:
					shoot_timer -= 0.2
					shot_count -= 1
					shoot()
			else:
				if shoot_timer > 0.9:
					shoot_timer = 0
					shot_count = 5

			return
		
		States.WAIT:
			rotation.z = move_toward(rotation.z, 0, dt)
			if state_time >= 1.0:
				current_state = States.DASH
		
		States.DASH:
			pass
		
		States.RETURN:
			pass


func on_enter_state() -> void:
	match current_state:
		States.SWAY:
			origin_position = self.global_position
			shot_count = 6
		
		States.DASH:
			$Hitbox3D.disabled = false
			var player = get_tree().get_first_node_in_group("PLAYER")
			if not player: return
			var direction : Vector3 = global_position.direction_to(player.global_position)
			var target_pos : Vector3 = global_position + direction * DASH_LENGTH
			var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
			tween.set_parallel()
			tween.tween_property(self, "global_position", target_pos, DASH_DURATION)
			tween.set_parallel(false)
			tween.tween_interval(0.5)
			tween.tween_property(self, "current_state", States.RETURN, 0.0)
		
		States.RETURN:
			$Hitbox3D.disabled = true
			var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
			tween.tween_property(self, "global_position", origin_position, 1.0)
			tween.tween_property(self, "current_state", States.SWAY, 0.0)


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
