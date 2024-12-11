class_name ResetSceneListener
extends Node


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.keycode == KEY_R and event.is_pressed() and !event.echo:
			get_tree().reload_current_scene()
