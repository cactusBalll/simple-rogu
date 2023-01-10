extends KinematicBody2D

class_name Player
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
#export var speed_scale = 100
var Bullet = preload("res://scenes/castspells/PlayerBullet.tscn")
onready var level := $".."

onready var speed_scale = Config.speed_scale
var speed = 5
var velocity: Vector2 = Vector2(0,0)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity = Vector2(0,0)
	if Input.is_action_pressed("ui_up"):
		velocity += Vector2(0,-1)
	if Input.is_action_pressed("ui_left"):
		velocity += Vector2(-1,0)
	if Input.is_action_pressed("ui_right"):
		velocity += Vector2(1,0) 
	if Input.is_action_pressed("ui_down"):
		velocity += Vector2(0,1)
		
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			#print(get_viewport().get_mouse_position())
			#print(position)
			#print(get_viewport_transform()*( position))
			var shoot_direction = \
				get_viewport().get_mouse_position() - \
				get_viewport_transform() * position
			var b = Bullet.instance()
			b.velocity = shoot_direction.normalized()
			b.position = position + shoot_direction.normalized() * speed * 5
			#print(b.position)
			level.add_child(b)
			
	
func _physics_process(delta):
	move_and_collide(velocity.normalized() * speed_scale * delta * speed)
	pass
