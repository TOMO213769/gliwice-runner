extends Node3D

@export var speed := 25.0
@export var despawn_z := -10.0

func _process(delta):
    translate(Vector3(0, 0, -speed * delta))
    if global_transform.origin.z < despawn_z:
        queue_free()

func set_speed(s):
    speed = s

func _on_area_body_entered(body):
    if body is CharacterBody3D:
        if body.has_method("die"):
            body.die()
