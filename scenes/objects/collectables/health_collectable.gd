extends Collectable3D

@export var healing_amount := 20.0

func on_collected() -> void:
	player.health += healing_amount
	
	self.queue_free() #delete self
