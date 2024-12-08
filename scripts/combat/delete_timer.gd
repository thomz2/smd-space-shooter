class_name DeleteTimer
extends Timer


func _ready() -> void: 
	#owner is the PackedScene (.tscn) that contains this node
	#queue_free() removes it from the scene tree and deletes it from memory
	timeout.connect(func(): owner.queue_free())
