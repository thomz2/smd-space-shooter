extends BasePauseScreen


func _ready() -> void:
	super()
	visible = false


func open():
	visible = true
	$VBoxContainer/BtnContinue.grab_focus()
	pass

func close():
	visible = false


func _on_btn_continue_pressed() -> void:
	_close()


func _on_btn_title_pressed() -> void:
	_close() #unpauses
	get_tree().change_scene_to_file("res://scenes/screens/main_menu.tscn")
