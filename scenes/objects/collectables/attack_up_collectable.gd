extends Collectable3D


func on_collected() -> void:
	player.stats.damage_percent += 25
	
	self.queue_free() #delete self
