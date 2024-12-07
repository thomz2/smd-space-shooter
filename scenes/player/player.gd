class_name Player
extends CombatCharacter3D


## In spatial units (meters?) per second.
var move_speed : float = 10.0

## In spatial units per second squared.
var accel : float = 50.0

## What bullet to spawn when shoot button is pressed.
@export var packed_bullet : PackedScene
#TODO: move this to separate PlayerShooter node


@onready var model = $Model




func shoot_bullet() -> void:
	var bullet : Bullet3D = packed_bullet.instantiate()
	get_tree().current_scene.add_child(bullet)
	bullet.global_position = self.global_position
	#bullet.global_rotation = self.global_rotation


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
	
	if Input.is_action_just_pressed("ui_accept"):
		shoot_bullet()


# replace normal behavior with custom animation
func _kill():
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
