extends Node3D

#essetially just a counter
@onready var current_level=0

#the monster we will be spawning in. 
@onready var monsters = {
	'asteroid': preload("res://scenes/enemies/asteroid.tscn"),
	'enemy_ship': preload("res://scenes/enemies/enemy_ship.tscn")
}
#A random number generator to spawn from alternating spawn points.
@onready var rand=RandomNumberGenerator.new()
@onready var dead_enemies = 0
@onready var current_enemy_count = 0

@export var waves_timer : Timer

func _ready():
	add_to_group("level")
	waves_timer.timeout.connect(_on_in_between_waves_timeout)
	
func get_dificulty(level):
	return level * 2 + 5

func get_random_monster():
	var keys = monsters.keys()
	var random_key = keys[rand.randi_range(0, keys.size() - 1)]
	return monsters[random_key]

func spawn_enemies():
	var can_spawn = true
	var max_enemies_on_screen = get_dificulty(current_level)
	while can_spawn:
		if current_enemy_count < max_enemies_on_screen: 
			var m : CombatCharacter3D = get_random_monster().instantiate()

			var spawn_length = self.get_child_count()-1 #we check the amount of children on our spawn holder
			var rand_num = rand.randi_range(0,spawn_length) #then make a random number in that range
			var spawn_postion = self.get_child(rand_num).global_position #We use that number to randomly select a spawner node position to use 

			get_tree().current_scene.add_child(m)
			m.global_position = spawn_postion
			m.rotate_y(PI)

			current_enemy_count += 1
		else:
			waves_timer.start() # between rounds
			current_enemy_count = 0
			can_spawn = false
		await get_tree().create_timer(0.9).timeout # between spawns
  
func update_level(level):
	print("its level ", level)
	spawn_enemies()

func _on_in_between_waves_timeout():
	print("Leaving level: ", current_level)
	current_level += 1
	update_level(current_level)
