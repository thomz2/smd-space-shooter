class_name PlayerDetectorArea3D
extends Area3D
## player_detector_area_3d.gd
## Detects players.
##
## A player is any physics body node that has the group "PLAYER" in its node groups.



signal player_entered(player:Node3D)

## If true, it runs [code]queue_free()[/code] on this node after after a player enters it.
@export var destroy_after_triggered : bool = false



## The virtual function scripts will implement.
func on_player_entered(player:Node3D) -> void:
	print_debug("This function is virtual. Please extend this class to implement functionality.")


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body:Node3D) -> void:
	if body.is_in_group("PLAYER"):
		on_player_entered(body)
		player_entered.emit()
