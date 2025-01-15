extends Collectable3D

var shot_inst = preload("res://scenes/player/shot/v_shot.tscn")

func on_collected():
	player.shot_component = shot_inst.instantiate()
