class_name OnLeaveScreenDespawn
extends VisibleOnScreenNotifier3D



func _ready() -> void:
	screen_exited.connect(on_screen_exited)

func on_screen_exited() -> void:
	get_parent().queue_free()
	print("i despawned")
