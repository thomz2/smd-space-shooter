class_name PlayerBulletReflectorArea3D
extends Area3D


@export var disabled : bool = false :
	set(value):
		disabled = value
		set_deferred("monitoring", not value)


func _ready() -> void:
	disabled = disabled #run setter
	body_entered.connect(_on_body_entered)

func _on_body_entered(body:Node3D) -> void:
	if body is Bullet3D:
		if body.main_hitbox and body.main_hitbox.hits_player():
			_reflect_bullet(body)

func _reflect_bullet(bullet:Bullet3D) -> void:
	bullet.set_global_forwards(-bullet.get_global_forwards())
	#revert target type for every bullet
	for child in bullet.get_children():
		if child is Hitbox3D:
			child.target_type = Hitbox3D.TargetType.ENEMY
