extends Collectable3D


func on_collected() -> void:
	player.stats.move_speed_percent += 30
	
	self.queue_free() #delete self
