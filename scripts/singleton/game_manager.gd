extends Node
## game_manager.gd

## The highest point score saved this game session. Not saved to disk.
var high_score : int = 0

## Current wave in the stage. Advances by 1 every time an enemy dies.
var wave : int = 0


## The player's point score gained throughout the run.
var score : int = 0 :
	set(value):
		score = value
		if score > high_score:
			high_score = score


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.keycode == KEY_R and event.is_pressed() and !event.echo:
			reset_level()


func gain_score(value) -> void:
	if value > 0:
		score += value
		#emit signal?


func reset_level() -> void:
	score = 0
	wave = 0
	get_tree().reload_current_scene()



func shake_camera(strength:float) -> void:
	var camera : Camera3D = get_viewport().get_camera_3d()
	for child in camera.get_children():
		if child is Camera3DShaker:
			child.apply_random_shake(strength)
