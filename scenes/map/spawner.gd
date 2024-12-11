extends Node3D

#essetially just a counter
@onready var current_level=0
#the level is the key the amount of monsters is the value
@onready var monster_dict={
 1:1, # level:amount_of_monsters
 2:2,
 3:4,
 4:8,
 5:30
}

#the monster we will be spawning in. 
@onready var monster=preload("res://scenes/enemies/asteroid.tscn")
#A random number generator to spawn from alternating spawn points.
@onready var rand=RandomNumberGenerator.new()
@onready var dead_enemies=0

@export var timer : Timer

func _ready():
 add_to_group("level")
 timer.timeout.connect(_on_in_between_waves_timeout)


func enemy_death():
 print("enemy death")
 dead_enemies+=1
 if dead_enemies==monster_dict[current_level]:
  timer.start()
  dead_enemies=0
 #get_tree().call_group("player", "award_points", 200)

func spawn_enemies():
 for i in range(monster_dict[current_level]):
  var m : CombatCharacter3D = monster.instantiate()
  print("spawning enemy")
  #we check the amount of children on our spawn holder 
  var spawn_length = self.get_child_count()-1
  #then make a random number in that range
  var rand_num = rand.randi_range(0,spawn_length)
  #We use that number to randomly select a spawner node position to use 
  var spawn_postion = self.get_child(rand_num).position
  #we add the monster as a child of the level
  #We set the monsters position to the spawn location
  m.position = spawn_postion
  m.killed.connect(enemy_death)
  add_child(m)
  #This is just a fast way to create a timer similar to wait in python
  await get_tree().create_timer(0.5).timeout
  

func update_level(level):
 match level:
  1:
   print("its level one")
   #additional stuff here like announcer saying: Wave 1!
  2:
   print("its level two")
  3:
   print("its level three")
  4:
   print("its level four")
  5:
   print("its level five")
 spawn_enemies()



func _on_in_between_waves_timeout():
 print("Leaving level: ", current_level)
 current_level+=1
 update_level(current_level)
