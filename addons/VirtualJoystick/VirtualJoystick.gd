# Virtual Joystick plugin for Godot Engine
#
# https://github.com/rohanrhu/virtual-joystick
#
# Licensed under MIT
# Copyright (C) 2020, Oğuzhan Eroğlu (https://oguzhaneroglu.com/) <rohanrhu2@gmail.com>

extends Area2D

export(Texture) var container_texture
export(Texture) var button_texture

onready var shape = $CollisionShape2D
onready var container:Sprite
onready var button:Sprite

var is_mouseover = false
var is_dragging = false
var is_trimming = false
var angle = 0.0
var velocity = Vector2.ZERO
var current_event = false

signal controlling(velocity)
signal trimming(velocity)
signal released

func _ready():
	connect("mouse_entered", self, "_on_mouse_entered")
	connect("mouse_exited", self, "_on_mouse_exited")

	container = Sprite.new()
	button = Sprite.new()

	add_child(container)
	add_child(button)

	container.texture = container_texture
	button.texture = button_texture

	container.global_position = global_position
	button.global_position = container.global_position

func _process(delta):
	pass

func _unhandled_input(event):
	if not (event is InputEventScreenDrag) and not (event is InputEventScreenTouch):
		return
	if (position - event.position).length()  > shape.shape.radius * scale.x:
		return 
	current_event = event


	if event is InputEventScreenTouch:
		
		print(event.index,event.position, event.pressed)
		is_dragging = event.pressed
		get_tree().set_input_as_handled()
		if not is_dragging:
			is_trimming = false
			button.global_position = container.global_position
			velocity = Vector2.ZERO
			angle = 0.0

			emit_signal("released")

	_process_button()

#func _input_event(viewport, event, shape_idx):
#	if not (event is InputEventScreenDrag) and not (event is InputEventScreenTouch):
#		return
#
#	current_event = event
#
#
#	if event is InputEventScreenTouch:
#		is_dragging = event.pressed
#		#get_tree().set_input_as_handled()
#		if not is_dragging:
#			is_trimming = false
#			button.global_position = container.global_position
#			velocity = Vector2.ZERO
#			angle = 0.0
#
#			emit_signal("released")
#
#	_process_button()

func _process_button():
	if is_dragging:
		button.global_position = current_event.position

		#var da = abs(button.global_position.x - container.global_position.x)
		#var db = abs(button.global_position.y - container.global_position.y)
		var dh = (button.global_position - container.global_position).length();

		var a = button.global_position.x - container.global_position.x
		var b = button.global_position.y - container.global_position.y
		var h = sqrt(pow(a, 2) + pow(b, 2));
		angle = atan2(a, b)

		is_trimming = h > shape.shape.radius * scale.x

		if is_trimming:
			var x = container.global_position.x + sin(angle) * shape.shape.radius * scale.x
			var y = container.global_position.y + cos(angle) * shape.shape.radius * scale.x

			button.global_position.x = x
			button.global_position.y = y

		var v = Vector2(sin(angle), cos(angle))
		var is_changed = velocity != v
		velocity = v

		if is_changed:
			emit_signal("controlling",velocity)

		if is_trimming:
			emit_signal("trimming",velocity)

func _on_mouse_entered():
	is_mouseover = true

func _on_mouse_exited():
	is_mouseover = false
