extends KinematicBody2D

class_name Player
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
#export var speed_scale = 100
var Bullet = preload("res://scenes/castspells/PlayerBullet.tscn")
onready var level := $".."
onready var buff_timer := $BuffTimer
onready var atkcd_timer := $AtkCD
onready var vjoy_move_ctrl := $"../UILayer/VirtualJoystick"
onready var vjoy_atk_ctrl := $"../UILayer/VJoyStickR"
onready var speed_scale = Config.speed_scale
var speed = 3.5
export(float) var defend = 0.0
export(bool) var joystick = true

signal hp_changed(hp, max_hp)
var hp = 100.0
var max_hp = 100.0


var freezed = false
var velocity: Vector2 = Vector2(0,0)



export(float) var atk_cd = 0.5
var weapon = null




var auto_heal = 0.0
# Called when the node enters the scene tree for the first time.
func _ready():
	atkcd_timer.wait_time = atk_cd
	atkcd_timer.connect("timeout",self, "perform_attack")
	buff_timer.connect("timeout", self, "defreeze")
	vjoy_move_ctrl.connect("controlling",self,"vjoystick_move")
	vjoy_move_ctrl.connect("released", self, "vjoystick_halt")
	vjoy_atk_ctrl.connect("trimming", self, "vjoystick_attack")
	vjoy_atk_ctrl.connect("released", self, "vjoystick_attack_halt")
	GlobalState.config_player(self)
	
	if auto_heal > 0.0:
		var timer := Timer.new()
		timer.autostart = true
		timer.wait_time = Config.heal_time
		timer.connect("timeout", self, "heal")
		self.add_child(timer)
	
	emit_signal("hp_changed", hp, max_hp)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if freezed or joystick:
		return
	velocity = Vector2(0,0)
	if Input.is_action_pressed("ui_up"):
		velocity += Vector2(0,-1)
	if Input.is_action_pressed("ui_left"):
		velocity += Vector2(-1,0)
	if Input.is_action_pressed("ui_right"):
		velocity += Vector2(1,0) 
	if Input.is_action_pressed("ui_down"):
		velocity += Vector2(0,1)

func vjoystick_move(v: Vector2):
	if joystick:
		velocity = v.normalized()
		
func vjoystick_halt():
	velocity = Vector2.ZERO

var atk_vec = null

func vjoystick_attack(v: Vector2):
	atk_vec = v

func vjoystick_attack_halt():
	atk_vec = null

func perform_attack():
	if atk_vec != null:
		for i in range(weapon.num):
			var b = Bullet.instance()
			var angle = atk_vec.normalized().angle() 
			var angle_u = angle + weapon.distribution / 2.0
			var angle_l = angle - weapon.distribution / 2.0
			b.velocity =  Vector2(1,0).rotated(angle_l + randf() * weapon.distribution)
			b.position = position + b.velocity * speed * 5
			b.config_bullet_with(weapon)
			#print(b.position)
			level.add_child(b)

func _unhandled_input(event):
	if freezed or joystick:
		return
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

# since we implement duck type, there's no explicit interface
# but every mob should implement this method
func attacked(damage: Damage):
	var val = damage.value - defend * (1 - damage.amp)
	hp -= val
	if damage.freeze > 0:
		freezed = true
		buff_timer.start(damage.freeze)
	emit_signal("hp_changed", hp, max_hp)
	pass
	
func defreeze():
	freezed = false
	
func heal():
	hp += auto_heal
	emit_signal("hp_changed", hp, max_hp)

func weapon_equip(weapon):
	atk_cd = weapon.cd
	self.weapon = weapon
