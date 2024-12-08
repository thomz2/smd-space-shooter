@tool
@icon("res://scripts/combat/hitbox_3d_icon.png")
class_name Hitbox3D
extends Area3D
## hitbox_3d.gd
## Detects when a CombatCharacter3D enters its bounds, and applies damage.

signal destroyed

enum TargetType { NONE, ENEMY, PLAYER, BOTH }



## If [code]disabled[/code] is true, this hitbox won't detect any collisions.
@export var disabled : bool = false :
	set(value): # custom setter
		disabled = value
		#monitorable = false # doesn't need to be detected by others
		set_deferred("monitoring", !disabled)
		set_deferred("process_mode", PROCESS_MODE_DISABLED if disabled else PROCESS_MODE_INHERIT)

## What type of character this hitbox should hit and damage. Automatically sets collision masks.
@export var target_type : TargetType = TargetType.NONE :
	set(value):
		target_type = value

		collision_layer = 0 
		collision_mask = 0 # reset masks
		match target_type:
			TargetType.NONE:
				pass
			TargetType.ENEMY:
				set_collision_mask_value(3, true)
			TargetType.PLAYER:
				set_collision_mask_value(2, true)
			TargetType.BOTH:
				set_collision_mask_value(2, true)
				set_collision_mask_value(3, true)

## How much damage to apply on a given target.
@export var damage : float = 10.0

## If true, it runs [code]queue_free()[/code] on this node after it finds a valid target.
@export var destroy_after_collision : bool = false




func _ready():
	# when added in the editor
	if Engine.is_editor_hint():
		monitorable = false
		if target_type == TargetType.NONE:
			target_type = TargetType.NONE # run setter function
	# when created in the game
	else:
		body_entered.connect(_on_body_entered)


## Override this if you want to play an animation when this is destroyed.
func destroy() -> void:
	queue_free()


func _on_body_entered(body:Node3D):
	if body is CombatCharacter3D:
		body.health -= damage
		if destroy_after_collision and not Engine.is_editor_hint():
			destroy()
			destroyed.emit()
