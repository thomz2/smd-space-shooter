extends Node
class_name OnDeathSpawnCollectable

@export var awards = {
	"health": {
		"scene": preload("res://scenes/objects/collectables/health_collectable.tscn"),
		"chance": 1, # one in five
	},
} 

func _ready() -> void:
	if owner is CombatCharacter3D:
		owner.killed.connect(award_collectable)
	elif get_parent() is CombatCharacter3D:
		get_parent().killed.connect(award_collectable)


func award_collectable() -> void:
	var min_range = -1.2 
	var max_range =  1.2 

	for val in awards.keys():
		var rand_num = randi_range(0, awards[val]["chance"])
		if rand_num == 0:  
			var collectable = awards[val]["scene"].instantiate()
			get_tree().current_scene.add_child(collectable)
			collectable.global_position = owner.global_position + Vector3(0, randf_range(min_range, max_range), randf_range(min_range, max_range))
