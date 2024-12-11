@tool
@icon("res://scripts/combat/bullet_3d_icon.png")
class_name Bullet3D
extends CharacterBody3D
## A bullet that always flies forwards, towards negative Z.
## It does not use any collisions.
## To damage targets, add a child Hitbox3D.

## The speed this bullet has when created (can be changed later)
@export var initial_speed := 50.0
var speed : float = 0.0

## After this many seconds, run queue_free() on the bullet. Useful for despawning bullets with time.
@export var lifespan : float = 10.0
var lifetime : float = 0.0

## For connecting signals automatically
@export var main_hitbox : Hitbox3D = null

## Runs when this bullet's hitbox collides with something. Override this if you want to play an animation when this is destroyed.
func destroy() -> void:
	queue_free()

## Runs when this bullet's lifetime ends. Override this if you want to play an animation when it fizzles.
func expire() -> void:
	queue_free()


func _ready() -> void:
	set_collision_layer_value(4, true)
	if Engine.is_editor_hint():
		collision_layer = 0
		collision_mask = 0
		#set_deferred("collision_layer", 0)
		#set_deferred("collision_mask", 0)
		return
	
	speed = initial_speed
	# try finding at least some hitbox idk
	if not main_hitbox:
		for child in get_children():
			if child is Hitbox3D:
				main_hitbox = child
				break
	# connect signals
	if main_hitbox:
		main_hitbox.destroyed.connect(self.destroy)


func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint(): return #don't run deletion code on the editor please
	
	velocity = get_global_forwards() * speed
	move_and_slide()
	
	lifetime += delta
	if lifetime >= lifespan: expire() #don't play animation


func get_global_forwards() -> Vector3:
	return -global_basis.z

func set_global_forwards(forwards:Vector3) -> void:
	look_at(global_position + forwards, Vector3.UP)
