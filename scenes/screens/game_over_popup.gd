extends Control

var timestop_tween : Tween

func _ready() -> void:
	$VBoxContainer/BtnReset.pressed.connect(_on_btn_reset_pressed)
	$VBoxContainer/BtnTitle.pressed.connect(_on_btn_title_pressed)
	
	timestop_tween = create_tween()
	timestop_tween.tween_interval(0.8)
	timestop_tween.tween_property(Engine, "time_scale", 0.0, 0.5)


func _on_btn_reset_pressed() -> void:
	timestop_tween.stop()
	Engine.time_scale = 1.0
	GameManager.reset_level()


func _on_btn_title_pressed() -> void:
	timestop_tween.stop()
	Engine.time_scale = 1.0
	get_tree().change_scene_to_file("res://scenes/screens/main_menu.tscn")
