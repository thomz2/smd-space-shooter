extends Collectable3D

func on_collected() -> void:
	player.stats.max_health += 20
	player.health += 20
	
	self.queue_free() #delete self
