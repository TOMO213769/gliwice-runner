extends Node3D

@export var spawn_interval := 1.0
@export var spawn_z := 60.0
@export var lanes := [-3.0, 0.0, 3.0]

@export var obstacle_scenes: Array = []
@export var coin_scene: PackedScene
@export var powerup_scene: PackedScene

var timer := 0.0
var speed := 25.0
var difficulty_timer := 0.0

func _process(delta):
    timer -= delta
    difficulty_timer += delta
    # optionally increase speed over time
    if difficulty_timer > 15.0:
        speed += 2.0
        difficulty_timer = 0.0

    if timer <= 0.0:
        _spawn_wave()
        timer = spawn_interval

func _spawn_wave():
    var count = randi() % 3
    for i in range(count):
        _spawn_obstacle()
    if randi() % 100 < 60:
        _spawn_coins_line()
    elif randi() % 100 < 10:
        _spawn_powerup()

func _spawn_obstacle():
    if obstacle_scenes.size() == 0:
        return
    var scene = obstacle_scenes[randi() % obstacle_scenes.size()]
    var instance = scene.instantiate()
    var lane_x = lanes[randi() % lanes.size()]
    instance.global_transform.origin = Vector3(lane_x, 0.0, spawn_z + randf() * 10.0)
    if instance.has_method("set_speed"):
        instance.set_speed(speed)
    add_child(instance)

func _spawn_coins_line():
    var start_z = spawn_z + 5.0
    var lane_x = lanes[randi() % lanes.size()]
    for i in range(5):
        if coin_scene:
            var coin = coin_scene.instantiate()
            coin.global_transform.origin = Vector3(lane_x, 0.8, start_z + i * 2.0)
            add_child(coin)

func _spawn_powerup():
    if powerup_scene:
        var pu = powerup_scene.instantiate()
        var lane_x = lanes[randi() % lanes.size()]
        pu.global_transform.origin = Vector3(lane_x, 1.0, spawn_z + 5.0)
        add_child(pu)
