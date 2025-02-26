extends AnimationPlayer

func _ready() -> void:
	pass


func _on_enemy_ship_health_changed(new_amount: float, delta: float) -> void:
	self.play("flash", -1, 1.5)
	pass # Replace with function body.
