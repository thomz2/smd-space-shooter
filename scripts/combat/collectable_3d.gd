@icon("res://scripts/combat/collectable_3d_icon.png")
class_name Collectable3D
extends Node3D

signal collected()

## At which distance should this collectable start flying towards the player
@export var distance_to_magnetize : float = 5.0

## At which distance should this collectable
@export var distance_to_collect : float = 0.5

@export var magnetize_speed : float = 10.0

var player : Player = null
var is_flying_towards_player := false
var was_collected := false


func on_collected() -> void: pass # virtual function


func _physics_process(delta : float) -> void:
	if was_collected: return #exit
	
	if player == null:
		player = get_tree().get_first_node_in_group("PLAYER")
		return #try again next frame
	
	if not is_flying_towards_player:
		var squared_distance_to_player = player.global_position.distance_squared_to(self.global_position)
		if squared_distance_to_player <= distance_to_magnetize * distance_to_magnetize:
			is_flying_towards_player = true
	
	else:
		#move towards player
		global_position = global_position.move_toward(player.global_position, magnetize_speed * delta)
		
		var squared_distance_to_player = player.global_position.distance_squared_to(self.global_position)
		if squared_distance_to_player <= distance_to_collect * distance_to_collect:
			AudioManager.play_sfx("collect.wav")
			was_collected = true
			collected.emit()
			on_collected()
