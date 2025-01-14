@icon("res://scripts/combat/combat_character_3d_icon.png")
class_name CombatCharacter3D
extends CharacterBody3D


signal killed
signal health_changed(new_amount:float, delta:float)


@export var max_health : float = 10.0:
	set(value):
		max_health = max(1.0, value)
		health = health #run setter

var health : float = max_health :
	set(value): # custom setter function
		if health <= 0: return # don't process damage if already dead
		var old_health := health
		health = clamp(value, 0, max_health)
		health_changed.emit(health, value-old_health)
		if health <= 0:
			kill()


func _ready() -> void:
	health = max_health


func kill() -> void:
	killed.emit()
	queue_free() # deletes the node and its children.
