extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const directions = [Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN]
enum State{Chasing, Idle}
var state = State.Idle # 状态，再追逐玩家或者空闲
var speed_scale = Config.speed_scale
var idle_velocity = Vector2(0, 0)
export var speed = 2
onready var timer = $AITimer
var player: Player = null # should be init by caller
export var chasing_range = 100 # might be modified
# Called when the node enters the scene tree for the first time.
func _ready():
	timer.connect("timeout", self, "idle_change_direction")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
func idle_change_direction():
	idle_velocity = directions[randi() % 4]
	
func _physics_process(delta):
	if (player.position - position).length() < chasing_range:
		state = State.Chasing
	else:
		state = State.Idle
	if state == State.Idle:
		move_and_collide(idle_velocity * speed_scale * speed * delta)
	elif state == State.Chasing:
		var velocity = (player.position - position).normalized()
		move_and_collide(velocity * speed_scale * speed * delta)
