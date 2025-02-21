class_name BaseBossCharacter
extends CombatCharacter3D



func _ready() -> void:
	super()
	grow_health_from_wave()
	killed.connect(spawn_items_on_death)


## This is ran after _ready() to automatically adapt the boss max health
## to increase as the game goes on, making them harder.
func grow_health_from_wave() -> void:
	var wave := GameManager.wave
	max_health *= 1 + 0.2*(floor(wave/4) - 1) # +20% every subsequent boss.
	health = max_health


## This should be called on death to randomize and generate the items.
## Note that if one item is selected, the other should despawn (use signals).
func spawn_items_on_death() -> void:
	#TODO
	pass
