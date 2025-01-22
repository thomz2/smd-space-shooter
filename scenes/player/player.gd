@icon("res://scenes/player/player_icon.png")
class_name Player
extends CombatCharacter3D


var stats : PlayerStats = null

## In spatial units (meters?) per second.
var move_speed : float = 10.0

## In spatial units per second squared.
var accel : float = 50.0

## If positive, the player is dodging, and represents time in seconds until the dodge ends.
## If negative, the player is not dodging
var dodge_timer : float = 0.0

## If positive, player is invincible (and is_invincible is set)
var invincibility_timer : float = 0.0

var is_invincible : bool = false :
	set(value):
		if value == is_invincible: return #update only if needed
		is_invincible = value
		if value: #disable collisions for player
			set_collision_layer_value(2, false)
		else:
			set_collision_layer_value(2, true)
		

## The game over popup.
var packed_game_over : PackedScene = preload("res://scenes/screens/game_over_popup.tscn")

@onready var model = $Model
@onready var reflector = $PlayerBulletReflectorArea3D

## The current shot component attached to the player
@export var shot_component : PlayerShotComponent :
	set(value):
		# remove old shot components
		for child in self.get_children():
			if child is PlayerShotComponent:
				self.remove_child(child)
				# if changing to a different shot, delete the old one
				if value != child: child.queue_free()
		
		# add the new shot component
		shot_component = value
		self.add_child(value)



func _ready() -> void:
	GameManager.player = self
	#TODO: load stats from save data for meta progression
	stats = PlayerStats.new()
	
	super()
	health_changed.connect(_on_health_changed)



func _on_health_changed(_amount, delta_health) -> void:
	if delta_health < 0: #damage
		GameManager.shake_camera(0.5)
		invincibility_timer = 1.0
		$CollisionSFX.play()
	else: #heal
		#TODO: play healing sfx
		pass

func _on_stats_max_health_changed() -> void:
	max_health = stats.max_health
	health = stats.max_health

func dodge() -> void:
	$DodgingSFX.play()
	$ReflectParticle.restart()
	dodge_timer = 0.8
	invincibility_timer = 0.5
	var active_reflect_timer = 0.4
	
	var rotation_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	rotation_tween.tween_property(self, "rotation_degrees:z", 360, dodge_timer+0.1).from(0)
	
	#var invincibility_tween = create_tween()
	#invincibility_tween.tween_property(self, "invincibility_timer", 0.6, 0)
	#invincibility_tween.tween_interval(active_reflect_timer)
	#invincibility_tween.tween_property(self, "invincibility_timer", 0.0, 0)
	
	var reflect_tween = create_tween()
	reflect_tween.tween_property(reflector, "disabled", false, 0)
	reflect_tween.tween_interval(active_reflect_timer)
	reflect_tween.tween_property(reflector, "disabled", true, 0)
	


# called every physics frame
func _physics_process(delta: float) -> void:
	var input_direction := Input.get_vector("ui_left", "ui_right", "ui_down", "ui_up")
	if input_direction != Vector2.ZERO: 
		input_direction = input_direction.normalized()
	
	if dodge_timer > 0.6: input_direction *= 2.0 #buff move speed on dodge
	
	# to move the ship, we first modify its velocity, then call move_and_slide().
	# move_and_slide() already multiplies velocity by delta time.
	var final_move_speed = move_speed * stats.get_move_speed_mult()
	var final_accel = accel * stats.get_move_speed_mult()
	velocity.y = move_toward(velocity.y, final_move_speed * input_direction.y, delta * final_accel)
	velocity.z = move_toward(velocity.z, final_move_speed * -input_direction.x, delta * final_accel) # negative z is forwards
	move_and_slide()
	
	# rotation effect for the model
	rotation_degrees.x = clamp(velocity.y * 2, -30, 30)
	
	if invincibility_timer >= 0:
		is_invincible = true
		invincibility_timer -= delta
	else:
		is_invincible = false
	#print_debug(invincibility_timer, is_invincible)
	if dodge_timer > 0: 
		dodge_timer -= delta
		#if dodge_timer <= 0: #trying on tweeners for now
			#is_invincible = false
			#reflector.disabled = true
	if dodge_timer <= 0 and Input.is_action_just_pressed("dodge"):
		dodge()


# replace normal behavior with custom animation
func kill():
	# can't collide if dead
	set_deferred("collision_layer", 0)
	set_deferred("collision_mask", 0)
	
	# death animation
	var move_tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
	move_tween.tween_property(self, "global_position", global_position + Vector3.DOWN*50 + -basis.z*30, 2.0)
	
	var rotation_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	rotation_tween.tween_property(self, "rotation_degrees:z", 720, 2.0).from(0)
	rotation_tween.parallel() # makes the next command parallel to this last one
	rotation_tween.tween_property(self, "rotation_degrees:x", -60, 2.0).from(0)
	
	# restart scene
	# TODO: replace with death screen.
	await get_tree().create_timer(0.5, true, false, true).timeout
	get_tree().current_scene.add_child(packed_game_over.instantiate())
