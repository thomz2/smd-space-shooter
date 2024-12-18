extends Node3D



@onready var ship_model = $Ship/ShipModel
@onready var ship_root = $Ship
@onready var player = $Player
@onready var player_target = $PlayerTarget

func _ready() -> void:
	AudioManager.play_music("background.mp3")
	$BtnPlay.pressed.connect(_on_btn_play_pressed)
	
	# this makes the button focused / selected. Z or Enter or Space should press it.
	$BtnPlay.grab_focus()


func _process(delta: float) -> void:
	#var hor_input : float = Input.get_axis("ui_left", "ui_right")
	#var ver_input : float = Input.get_axis("ui_down", "ui_up")
	#ship_root.position.x = lerp(ship_root.position.x, hor_input*2.0, delta)
	#ship_root.position.y = lerp(ship_root.position.y, ver_input*2.0, delta)
	#ship_model.position.y = 0 + 0.3*sin( float(Time.get_ticks_msec()) / 1000.0 )
	#ship_model.rotation.x = 0 + 0.2*cos(3 + float(Time.get_ticks_msec()) / 1000.0 )
	pass

func _physics_process(delta: float) -> void:
	player_target.position.y = 0.5*sin( 2*float(Time.get_ticks_msec()) / 1000.0 )
	player.position = lerp(player.position, player_target.position, delta*5) 
	

func _on_btn_play_pressed() -> void:
	## Change to game scene; TODO swap this for something else later.
	get_tree().change_scene_to_file("res://scenes/map/test_infinity.tscn")
