class_name CombatCharacter3D
extends CharacterBody3D


signal killed


@export var health := 10.0 :
	set(value): # custom setter function
		health = value
		if health <= 0:
			_kill()


func _kill() -> void:
	killed.emit()
	queue_free() # deletes the node and its children.
