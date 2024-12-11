extends CanvasLayer



@export var health_bar : ProgressBar
@export var health_label : Label


@onready var player : Player = owner


func _ready() -> void:
	player.killed.connect(_on_player_killed)
	
	health_bar.max_value = player.max_health
	health_bar.value = player.max_health


func _process(delta:float) -> void:
	#we're updating the hud every frame instead of listening to changes
	#it's less performant but perf is not an issue here
	health_label.text = "%.1f" % player.health
	#lerp over time makes a smoothing behavior
	health_bar.value = lerp(health_bar.value, player.health, delta*10)
	


func _on_player_killed() -> void:
	health_bar.value = 0
