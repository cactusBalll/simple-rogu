extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var value: float = 10.0
var freeze: float = 0.0
var amp: float = 0.0
var distance: float = INF # 最大射程
var distance_moved: float = 0

var speed = 3
var speed_scale = Config.speed_scale
var velocity = Vector2(0,0)

onready var sprite = $Sprite
#var Damage := preload("res://scripts/Damage.gd")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
func config_bullet_with(weapon):
	value = weapon.value
	freeze = weapon.freeze
	amp = weapon.amp
	distance = weapon.distance
	speed = weapon.bullet_speed
	if weapon.has_method("on_bullet_generated"):
		weapon.on_bullet_generated(self)
func _physics_process(delta):
	var move_distance = delta * speed_scale * speed * velocity
	distance_moved += move_distance.length()
	var collide_info := move_and_collide(move_distance)
	if collide_info != null:
		var collider := collide_info.collider
		if collider.has_method("attacked"):
			collider.attacked(get_damage())
		queue_free()
		return
	if distance_moved >= distance:
		queue_free()
		return
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func get_damage():
	return Damage.new(value, freeze, amp)
