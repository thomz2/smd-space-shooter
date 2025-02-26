extends AnimationPlayer

func _ready() -> void:
	pass


func _on_enemy_ship_health_changed(new_amount: float, delta: float) -> void:
	self.play("flash", -1, 1.5)


func _on_tank_ship_health_changed(new_amount: float, delta: float) -> void:
	self.play("flash", -1, 1.5)


func _on_tiny_ship_health_changed(new_amount: float, delta: float) -> void:
	self.play("flash", -1, 1.5)


func _on_asteroid_health_changed(new_amount: float, delta: float) -> void:
	self.play("flash", -1, 1.5)


func _on_boss_1_health_changed(new_amount: float, delta: float) -> void:
	self.play("flash", -1, 1.5)


func _on_boss_2_health_changed(new_amount: float, delta: float) -> void:
	self.play("flash", -1, 1.5)


func _on_boss_3_health_changed(new_amount: float, delta: float) -> void:
	self.play("flash", -1, 1.5)
