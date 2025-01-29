extends Panel

@onready var button_increase: Button = $RightButton
@onready var button_decrease: Button = $LeftButton

func _ready() -> void:
	GameManager.wave = 1
	button_increase.pressed.connect(_on_button_increase_pressed)
	button_decrease.pressed.connect(_on_button_decrease_pressed)
	update_state()
	
func _on_button_increase_pressed() -> void:
	GameManager.wave += 1
	update_state()

func _on_button_decrease_pressed() -> void:
	if (GameManager.wave > 1):
		GameManager.wave -= 1
	update_state()

func update_state() -> void:
	$LevelLabel.text = str(GameManager.wave)
