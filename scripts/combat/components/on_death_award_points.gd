@icon("res://scripts/combat/components/on_death_award_points_icon.png")
class_name OnDeathAwardPoints
extends Node
## on_death_award_points.gd
##
## Increases the current Score by a set amount of points
## when the parent character is defeated.


## How many score points to award when this character dies.
@export var score : int = 100


func _ready() -> void:
	if owner is CombatCharacter3D:
		owner.killed.connect(award_points)
	elif get_parent() is CombatCharacter3D:
		get_parent().killed.connect(award_points)


func award_points() -> void:
	GameManager.gain_score(score)
