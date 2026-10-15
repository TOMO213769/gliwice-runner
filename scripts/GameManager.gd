# Minimal GameManager placeholder
extends Node

var score := 0
var coins := 0

func _ready():
    print("GameManager ready")

func add_coins(n):
    coins += n
    _update_ui()

func add_score(n):
    score += n
    _update_ui()

func _update_ui():
    # placeholder: update labels if present
    pass

func on_player_died():
    # show game over, stop spawner, etc.
    get_tree().paused = true
    print("Game Over")
