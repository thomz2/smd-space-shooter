extends Control


func _ready() -> void:
	$VBoxContainer/BtnReset.pressed.connect(_on_btn_reset_pressed)
	$VBoxContainer/BtnTitle.pressed.connect(_on_btn_title_pressed)


func _on_btn_reset_pressed() -> void:
	GameManager.reset_level()


func _on_btn_title_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/screens/main_menu.tscn")
