extends Node3D



@onready var ship_model = $Ship/ShipModel
@onready var ship_root = $Ship


func _ready() -> void:
	$BtnPlay.pressed.connect(_on_btn_play_pressed)
	
	# this makes the button focused / selected. Z or Enter or Space should press it.
	$BtnPlay.grab_focus()


func _process(delta: float) -> void:
	var hor_input : float = Input.get_axis("ui_left", "ui_right")
	var ver_input : float = Input.get_axis("ui_down", "ui_up")
	ship_root.position.x = lerp(ship_root.position.x, hor_input*2.0, delta)
	ship_root.position.y = lerp(ship_root.position.y, ver_input*2.0, delta)
	ship_model.position.y = 0 + 0.3*sin( float(Time.get_ticks_msec()) / 1000.0 )
	ship_model.rotation.x = 0 + 0.2*cos(3 + float(Time.get_ticks_msec()) / 1000.0 )


func _on_btn_play_pressed() -> void:
	## Change to game scene; TODO swap this for something else later.
	get_tree().change_scene_to_file("res://scenes/map/test_map.tscn")
