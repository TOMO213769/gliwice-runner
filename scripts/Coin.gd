extends Area3D

@export var value := 1

signal collected(val)

func _ready():
    connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body):
    if body is CharacterBody3D:
        emit_signal("collected", value)
        queue_free()
