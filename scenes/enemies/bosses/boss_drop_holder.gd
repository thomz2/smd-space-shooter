class_name BossDropHolder
extends Node3D


@export var amount_to_drop : int = 2
@export var possible_drops : Array[PackedScene] = [] #all drops should be Collectable3D

## save what packed scenes were chosen
var picked_packed_drops : Array[PackedScene] = []

## the actual nodes spawned, so can be deleted later
var spawned_drops : Array[Collectable3D] = []

func _ready() -> void:
	var boss : BaseBossCharacter = get_parent()
	boss.killed.connect(on_boss_killed)


func on_boss_killed() -> void:
	#reparent this node to not be deleted alongside the boss
	reparent(get_tree().current_scene, true)
	
	for i in range(amount_to_drop):
		#filter func to not spawn repeats
		var filtered_drops := possible_drops.filter(func(elem): return elem not in picked_packed_drops)
		var packed_drop = filtered_drops.pick_random()
		if packed_drop == null: continue
		picked_packed_drops.append(packed_drop)
		var drop : Collectable3D = packed_drop.instantiate()
		spawned_drops.append(drop)
		add_child(drop) #add to scene
		#set positions
		drop.global_position.x = 0
		drop.global_position.y = 0 + 4*(i - 0.5*(amount_to_drop-1))
		#connect signal
		drop.collected.connect(on_collectable_collected.bind(drop))


func on_collectable_collected(collected_drop:Collectable3D) -> void:
	#when one is collected, delete the others
	for drop in spawned_drops:
		if drop != collected_drop: 
			drop.is_flying_towards_player = false
			drop.queue_free()
