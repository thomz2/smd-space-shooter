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
		if body.main_hitbox and body.main_hitbox.hits_player() and body.can_be_reflected:
			_reflect_bullet(body)

# Obs.: essa função não lida com o tiro da nave tank
# em vez disso, vá para res://scenes/enemies/tank_ship_bullet.gd
func _reflect_bullet(bullet:Bullet3D) -> void:
	bullet.set_global_forwards(-bullet.get_global_forwards())
	#revert target type for every bullet
	for child in bullet.get_children():
		if child is Hitbox3D:
			child.target_type = Hitbox3D.TargetType.ENEMY
		if child is MeshInstance3D:
			var mesh_instance : MeshInstance3D = child
			if mesh_instance.mesh:
				if mesh_instance.mesh is CapsuleMesh:
					mesh_instance.mesh.material = mesh_instance.mesh.material.duplicate(true)
					if (mesh_instance.mesh.material.albedo_color != Color(1,1,1)):
						mesh_instance.mesh.material.albedo_color = Color(0, 1, 1)
				else:
					var material = mesh_instance.mesh.surface_get_material(0)
					if material:
						var new_material = material.duplicate(true)
						mesh_instance.mesh.surface_set_material(0, new_material)
						if (new_material.albedo_color != Color(1,1,1)):
							new_material.albedo_color = Color(0, 1, 1)
			else:
				print("nenhum mesh atribuido")

	#funky componentization
	if bullet.has_method("on_reflected"):
		bullet.call("on_reflected")
