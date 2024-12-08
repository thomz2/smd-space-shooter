class_name OnDeathBulletSpawner
extends Node3D
## on_death_bullet_spawner.gd
##
## Spawns a set amount of bullets when the CombatCharacter3D 
## owned by this node is killed. Bullets are equally spaced.


## The bullet to spawn; Scene of type Bullet3D
@export var packed_bullet : PackedScene

## How many bullets does this node spawn?
@export var amount_to_spawn : int = 4

## By default, the first bullet spawns towards negative Z.
## Use this offset to rotate the angle of the first bullet.
@export var angle_offset_degrees : float = 0.0

## Speed to override the bullet's initial speed.
## Keep it to -1 to not override.
@export var initial_speed_override : float = -1


func _ready() -> void:
	if owner is CombatCharacter3D:
		owner.killed.connect(spawn_bullets)
	elif get_parent() is CombatCharacter3D:
		get_parent().killed.connect(spawn_bullets)

func spawn_bullets() -> void:
	if amount_to_spawn <= 0: return
	
	var angle_step_degrees := 360.0 / amount_to_spawn
	var current_angle_degrees := angle_offset_degrees
	#var initial_position := self.global_position
	for i in range(amount_to_spawn):
		#make a node from a packed scene
		var bullet : Bullet3D = packed_bullet.instantiate()
		
		if initial_speed_override != -1:
			bullet.initial_speed = initial_speed_override
		
		#this adds the bullet to the scene tree
		get_tree().current_scene.add_child(bullet)
		
		#set position and rotation
		bullet.global_position = self.global_position
		bullet.rotate_x(deg_to_rad(current_angle_degrees))
		
		current_angle_degrees += angle_step_degrees
