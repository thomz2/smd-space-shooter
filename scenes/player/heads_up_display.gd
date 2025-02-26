extends CanvasLayer



@export var health_bar : ProgressBar
@export var health_label : Label
@export var score_label : Label

@onready var player : Player = owner


func _ready() -> void:
	player.killed.connect(_on_player_killed)
	
	
	health_bar.max_value = player.max_health
	health_bar.value = player.max_health
	
	await player.ready
	player.stats.max_health_changed.connect(_on_max_health_changed)


func _process(delta:float) -> void:
	#we're updating the hud every frame instead of listening to changes
	#it's less performant but perf is not an issue here
	health_label.text = "%.1f" % player.health
	#lerp over time makes a smoothing behavior
	health_bar.value = lerp(health_bar.value, player.health, delta*10)
	
	score_label.text  = "%08d       SCORE\n%08d   HISCORE" % [GameManager.score, GameManager.high_score]

func _on_max_health_changed() -> void:
	health_bar.max_value = player.max_health
	health_bar.value = player.health
	health_bar.get_minimum_size().x = 300 * player.max_health

func _on_player_killed() -> void:
	health_bar.value = 0
