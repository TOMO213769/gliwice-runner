extends CharacterBody3D

# Player for an endless-runner: lane switching, jump, slide.
@export var lanes := [-3.0, 0.0, 3.0]
@export var lane_change_speed := 12.0
@export var jump_speed := 12.0
@export var gravity := 30.0
@export var slide_time := 0.8

var lane := 1
var target_x := 0.0
var velocity := Vector3.ZERO

var sliding := false
var slide_timer := 0.0

# touch swipe
var touch_start := null
const SWIPE_THRESHOLD := 50

onready var col_shape := $CollisionShape
var original_capsule_height := 1.2
var original_capsule_radius := 0.3

func _ready():
    target_x = lanes[lane]

func _process(delta):
    # smooth horizontal move
    var pos = global_transform.origin
    pos.x = lerp(pos.x, target_x, clamp(lane_change_speed * delta, 0.0, 1.0))
    global_transform.origin = pos

    # slide timer
    if sliding:
        slide_timer -= delta
        if slide_timer <= 0.0:
            _end_slide()

func _physics_process(delta):
    # gravity + jump
    if not is_on_floor():
        velocity.y -= gravity * delta
    # apply vertical motion
    velocity = move_and_slide(velocity, Vector3.UP)

func _input(event):
    if event is InputEventScreenTouch:
        if event.pressed:
            touch_start = event.position
        else:
            if touch_start != null:
                var delta = event.position - touch_start
                _handle_swipe(delta)
            touch_start = null

func _unhandled_input(event):
    if event is InputEventKey and event.pressed:
        match event.keycode:
            KEY_LEFT, KEY_A:
                _move_left()
            KEY_RIGHT, KEY_D:
                _move_right()
            KEY_UP, KEY_W, KEY_SPACE:
                _jump()
            KEY_DOWN, KEY_S:
                _slide()

func _handle_swipe(delta: Vector2):
    if delta.length() < SWIPE_THRESHOLD:
        return
    if abs(delta.x) > abs(delta.y):
        if delta.x > 0:
            _move_right()
        else:
            _move_left()
    else:
        if delta.y < 0:
            _jump()
        else:
            _slide()

func _move_left():
    lane = max(lane - 1, 0)
    target_x = lanes[lane]

func _move_right():
    lane = min(lane + 1, lanes.size() - 1)
    target_x = lanes[lane]

func _jump():
    if is_on_floor() and not sliding:
        velocity.y = jump_speed

func _slide():
    if is_on_floor() and not sliding:
        sliding = true
        slide_timer = slide_time
        # reduce capsule height
        if col_shape and col_shape.shape is CapsuleShape3D:
            col_shape.shape.height = original_capsule_height * 0.5
            col_shape.shape.radius = original_capsule_radius * 0.9

func _end_slide():
    sliding = false
    if col_shape and col_shape.shape is CapsuleShape3D:
        col_shape.shape.height = original_capsule_height
        col_shape.shape.radius = original_capsule_radius

# call when colliding with obstacle
func die():
    # emit or handle death; basic placeholder
    get_tree().paused = true
    print("Player died")
