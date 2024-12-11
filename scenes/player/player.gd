class_name Player
extends CombatCharacter3D


## In spatial units (meters?) per second.
var move_speed : float = 10.0

## In spatial units per second squared.
var accel : float = 50.0

## If positive, the player is dodging, and represents time in seconds until the dodge ends.
## If negative, the player is not dodging
var dodge_timer : float = 0.0

var is_invincible : bool = false :
	set(value):
		is_invincible = value
		if value: #disable collisions for player
			set_collision_layer_value(2, false)
		else:
			set_collision_layer_value(2, true)

## What bullet to spawn when shoot button is pressed.
@export var packed_bullet : PackedScene
#TODO: move this to separate PlayerShooter node

@export var fire_rate = 0.2
var can_shoot : bool = true

@onready var model = $Model
@onready var reflector = $PlayerBulletReflectorArea3D

func _ready() -> void:
	var timer = Timer.new()
	timer.one_shot = true
	timer.wait_time = fire_rate
	timer.name = "ShootTimer"
	add_child(timer)
	timer.timeout.connect(_on_shoot_timer_timeout)

func _on_shoot_timer_timeout() -> void:
	can_shoot = true

func shoot_bullet() -> void:
	var bullet : Bullet3D = packed_bullet.instantiate()
	get_tree().current_scene.add_child(bullet)
	bullet.global_position = self.global_position
	#bullet.global_rotation = self.global_rotation

func dodge() -> void:
	dodge_timer = 0.5
	var active_reflect_timer = 0.3
	
	var rotation_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	rotation_tween.tween_property(self, "rotation_degrees:z", 360, dodge_timer).from(0)
	
	var invincibility_tween = create_tween()
	invincibility_tween.tween_property(self, "is_invincible", true, 0)
	invincibility_tween.tween_interval(active_reflect_timer)
	invincibility_tween.tween_property(self, "is_invincible", false, 0)
	
	var reflect_tween = create_tween()
	reflect_tween.tween_property(reflector, "disabled", false, 0)
	reflect_tween.tween_interval(active_reflect_timer)
	reflect_tween.tween_property(reflector, "disabled", true, 0)
	


# called every physics frame
func _physics_process(delta: float) -> void:
	var input_direction := Input.get_vector("ui_left", "ui_right", "ui_down", "ui_up")
	if input_direction != Vector2.ZERO: 
		input_direction = input_direction.normalized()
	
	# to move the ship, we first modify its velocity, then call move_and_slide().
	# move_and_slide() already multiplies velocity by delta time.
	velocity.y = move_toward(velocity.y, move_speed * input_direction.y, delta*accel)
	velocity.z = move_toward(velocity.z, move_speed * -input_direction.x, delta*accel) # negative z is forwards
	move_and_slide()
	
	# rotation effect for the model
	rotation_degrees.x = clamp(velocity.y * 2, -30, 30)
	
	#if Input.is_action_just_pressed("shoot"):
	if Input.is_action_pressed("shoot") and can_shoot:
		shoot_bullet()
		can_shoot = false
		$ShootTimer.start()
	
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
	await get_tree().create_timer(1.5, true, false, true).timeout
	get_tree().reload_current_scene()
