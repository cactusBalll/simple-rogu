extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var value: float = 10.0
var freeze: float = 0.0
var amp: float = 0.0
var speed = 3
var speed_scale = Config.speed_scale
var velocity = Vector2(0,0)
#var Damage := preload("res://scripts/Damage.gd")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	var collide := move_and_collide(delta * speed_scale * speed * velocity)
	if collide != null:
		queue_free()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func get_damage():
	return Damage.new(value, freeze, amp)
