extends Collectable3D

func on_collected() -> void:
	player.stats.max_health += 25
	player.health += 25
	
	self.queue_free() #delete self
