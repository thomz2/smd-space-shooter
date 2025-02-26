class_name PlayerShotComponent
extends Node3D

@export var is_player_controlled : bool = true

@export var packed_bullet : PackedScene

@export var fire_rate : float = 0.15
var fire_timer : float = 0.0

@onready var parent = get_parent()




func can_shoot() -> bool:
	if fire_timer > 0: return false
	
	if parent is Player:
		if parent.dodge_timer > 0 || parent.health <= 0: return false
	
	return true


func shoot() -> void:
	if not packed_bullet: printerr("No bullet to shoot!")
	var bullet : Bullet3D = packed_bullet.instantiate()
	get_tree().current_scene.add_child(bullet)
	
	# place at this node's center
	# TODO: place at shooting spot? use this node as a scene if we need multiple spots? hard code position offsets?
	bullet.global_position = self.global_position
	# rotate to face parent's facing
	bullet.set_global_forwards((-parent.global_basis.z).normalized())
	
	AudioManager.play_sfx("player_shot_normal.wav")


func _physics_process(delta: float) -> void:
	_update_timer(delta)
	
	if can_shoot():
		var should_shoot := true
		if is_player_controlled: should_shoot = Input.is_action_pressed("shoot")
		if should_shoot: 
			shoot()
			fire_timer += fire_rate


func _update_timer(delta: float) -> void:
	if (fire_timer > 0): fire_timer -= delta # simple timer as number
