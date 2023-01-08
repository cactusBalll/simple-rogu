extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity: Vector2 = Vector2(0,0)
	if Input.is_action_pressed("ui_up"):
		velocity = Vector2(0,-40) * delta
	if Input.is_action_pressed("ui_left"):
		velocity = Vector2(-40,0) * delta
	if Input.is_action_pressed("ui_right"):
		velocity = Vector2(40,0) * delta
	if Input.is_action_pressed("ui_down"):
		velocity = Vector2(0,40) * delta
	move_and_collide(velocity)
func _physics_process(delta):
	pass
