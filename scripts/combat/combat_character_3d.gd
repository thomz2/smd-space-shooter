@icon("res://scripts/combat/combat_character_3d_icon.png")
class_name CombatCharacter3D
extends CharacterBody3D


signal killed


@export var health := 10.0 :
	set(value): # custom setter function
		if health <= 0: return # don't process damage if already dead
		health = max(0, value)
		if health <= 0:
			_kill()


func _kill() -> void:
	killed.emit()
	queue_free() # deletes the node and its children.
