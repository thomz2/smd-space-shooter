class_name OnDeathParticleSpawner
extends Node3D
## on_death_particle_spawner.gd
##
## Spawns and activates all children of this node that are Particles


func _ready() -> void:
	if owner is CombatCharacter3D:
		owner.killed.connect(spawn_particles)
	elif get_parent() is CombatCharacter3D:
		get_parent().killed.connect(spawn_particles)
	
	for child in get_children():
		if child is GPUParticles3D and child.one_shot:
			child.finished.connect(child.queue_free)

func spawn_particles() -> void:
	for child in get_children():
		if child is GPUParticles3D:
			child.reparent(get_tree().current_scene, true)
			child.restart()
			child.emitting = true
			
			#await get_tree().create_timer(1.0).timeout
			#child.emitting = false
			#queue_free()
