extends KinematicBody2D

signal hp_changed(hp, max_hp)
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
export var damage = 10
export var defend = 0.0
export var hp = 10
export var max_hp = 10
var gen_power = 1 # 生成权重
var score = 1
# Called when the node enters the scene tree for the first time.
func _ready():
	timer.connect("timeout", self, "idle_change_direction")
	freeze_timer.connect("timeout", self, "defreeze")
	self.connect("hp_changed", self, "on_change_hp_bar")
	$HpBar.value = hp
	$HpBar.max_value = max_hp
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if hp <= 0:
		LevelState.current_monster_density -= gen_power
		GlobalState.add_score(GlobalState.level * score)
		queue_free()
	pass
func idle_change_direction():
	idle_velocity = directions[randi() % 4]
	
func _physics_process(delta):
	if (player.position - position).length() < chasing_range:
		state = State.Chasing
	else:
		state = State.Idle
	if freezed:
		return
	var collider_info
	if state == State.Idle:
		collider_info = move_and_collide(idle_velocity * speed_scale * speed * delta)
	elif state == State.Chasing:
		var velocity = (player.position - position).normalized()
		collider_info = move_and_collide(velocity * speed_scale * speed * delta)
	if collider_info != null and collider_info.collider.has_method("attacked"):
		var d = Damage.new(damage, 0.0, 0.0)
		var collider = collider_info.collider
		collider.attacked(d)
		queue_free()

onready var freeze_timer := $FreezeTimer	
var freezed = false
func attacked(damage: Damage):
	var val = damage.value - defend * (1 - damage.amp)
	hp -= val
	emit_signal("hp_changed", hp, max_hp)
	if damage.freeze > 0:
		freezed = true
		freeze_timer.start(damage.freeze)
	pass

func defreeze():
	freezed = false


func on_change_hp_bar(hp, max_hp):
	$HpBar.value = hp
	$HpBar.max_value = max_hp
