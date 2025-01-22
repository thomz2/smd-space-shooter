class_name PlayerStats
extends Resource


signal max_health_changed


@export var damage_percent : int = 100

@export var move_speed_percent : int = 100

@export var max_health : int = 100 :
	set(value):
		max_health = value
		max_health_changed.emit()

## TODO: add more stats?




func get_damage_mult() -> float:
	return damage_percent / 100.0

func get_move_speed_mult() -> float:
	return move_speed_percent / 100.0



func to_dict() -> Dictionary:
	return {
		'damage_percent': damage_percent,
		'move_speed_percent': move_speed_percent,
		'max_health': max_health,
	}

static func from_dict(dict:Dictionary) -> PlayerStats:
	var stats := PlayerStats.new()
	if dict['damage_percent']: stats.damage_percent = dict['damage_percent']
	if dict['move_speed_percent']: stats.move_speed_percent = dict['move_speed_percent']
	if dict['max_health']: stats.max_health = dict['max_health']
	
	return stats
