extends Node3D

#@onready var current_level=0

@onready var monsters = {
	'asteroid':   preload("res://scenes/enemies/asteroid.tscn"),
	'enemy_ship': preload("res://scenes/enemies/enemy_ship.tscn"),
	'tiny_ship':  preload("res://scenes/enemies/tiny_ship.tscn"),
	'tank_ship':  preload("res://scenes/enemies/tank_ship.tscn")
}

@onready var bosses = { #TODO: rename bosses
	'boss_1': preload("res://scenes/enemies/bosses/boss_1.tscn"),
	'boss_2': preload("res://scenes/enemies/bosses/boss_2.tscn"),
}

@onready var rand = RandomNumberGenerator.new()
@onready var dead_enemies = 0
@onready var current_enemy_count = 0

@export var waves_timer : Timer

func _ready():
	GameManager.wave -= 1 # Gambiarra
	add_to_group("level")
	waves_timer.timeout.connect(_on_in_between_waves_timeout)
	
	# start level right away
	await get_tree().create_timer(0.1).timeout
	_on_in_between_waves_timeout()


func get_dificulty():
	return ceil(GameManager.wave * 1.7) + 5


func get_random_monster():
	var possible_keys = []
	
	if GameManager.wave < 5:
		possible_keys.append("asteroid")
		
		# DEBUG:
		#possible_keys.append("enemy_ship")
		#possible_keys.append("tank_ship")
		#possible_keys.append("tiny_ship")
	
	if GameManager.wave >= 2:
		possible_keys.append("enemy_ship")
	if GameManager.wave >= 4:
		possible_keys.append("tank_ship")
	if GameManager.wave >= 7:
		possible_keys.append("tiny_ship")
	
	return monsters[possible_keys.pick_random()]

func get_random_boss():
	var possible_keys = []
	
	if GameManager.wave <= 12:
		possible_keys.append("boss_1")
	
	if GameManager.wave >= 8:
		possible_keys.append("boss_2")
	
	return bosses[possible_keys.pick_random()]


func spawn_enemies():
	if GameManager.wave % 4 == 0: # if multiple of four, spawn boss, exit this behavior
		spawn_boss()
		return #don't spawn any enemies
	
	var can_spawn = true
	var max_enemies_on_screen = get_dificulty()
	while can_spawn:
		if current_enemy_count < max_enemies_on_screen: 
			var monster : CombatCharacter3D = get_random_monster().instantiate()
			
			var spawn_length = self.get_child_count()-1 
			var rand_num = rand.randi_range(0,spawn_length) 
			var spawn_postion = self.get_child(rand_num).global_position 
			
			get_tree().current_scene.add_child(monster)
			monster.global_position = spawn_postion
			monster.rotate_y(PI)
			
			current_enemy_count += 1
		else:
			waves_timer.start() # between rounds
			current_enemy_count = 0
			can_spawn = false
		
		await get_tree().create_timer(1.7).timeout # between spawns
  

func spawn_boss():
	var packed_boss : PackedScene = get_random_boss()
	
	var boss_enemy : CombatCharacter3D = packed_boss.instantiate()
	get_tree().current_scene.add_child(boss_enemy)
	#set position
	boss_enemy.global_position = self.get_child(0).global_position #spawner1
	boss_enemy.global_position.y = 0 #height center
	boss_enemy.global_position.x = 0 #depth center
	#connect death signal to advance
	boss_enemy.killed.connect(self._on_boss_defeated)
	
	
	print_debug("position: ", boss_enemy.global_position)

func update_level(level):
	print("its level ", level)
	spawn_enemies()


func _on_in_between_waves_timeout():
	print("Leaving level: ", GameManager.wave)
	GameManager.wave += 1
	update_level(GameManager.wave)


func _on_boss_defeated():
	await get_tree().create_timer(3.0).timeout
	GameManager.wave += 1
	update_level(GameManager.wave)
