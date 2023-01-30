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
# begin mahoshojo
var mahoshojo_enabled := false
var polution := 0.0
var max_polution := 100.0
var polute_timer: Timer = null
onready var maho_button := $"../UILayer/Maho"
func polute():
	#print("called")
	polution += 5.0
func endable_mahoshojo():
	GlobalState.madoka_genned = true
	mahoshojo_enabled = true
	polute_timer.start()
	soulgem_bar.visible = true
	maho_button.visible = true

func maho_powar():
	var buff = Weapons.TBMaho.new()
	timed_buff_on(buff)
	polution += 40.0
	$"../UILayer/Maho".disabled = true
	get_tree().create_timer(65).connect("timeout", self,"enable_maho_powar_btn")
func enable_maho_powar_btn():
	$"../UILayer/Maho".disabled = false
# end mahoshojo
	
var skill = null
var skill_progress = 0.0
var skill_cd = 1.0

var freezed = false
var invincible = false # 无敌
var invincible_timer
var velocity: Vector2 = Vector2(0,0)



export(float) var atk_cd = 0.5
var weapon = null

var extra_atk = 0.0
var extra_amp = 0.0
var extra_greedy = 0.0

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
	var btn = $"../UILayer/Skill"
	btn.connect("pressed", self, "trig_skill")
	GlobalState.config_player(self)
	
	if true or auto_heal > 0.0:
		var timer := Timer.new()
		timer.autostart = true
		timer.wait_time = Config.heal_time
		timer.connect("timeout", self, "heal")
		self.add_child(timer)
	
	invincible_timer = Timer.new()
	invincible_timer.connect("timeout", self, "deinvincible")
	self.add_child(invincible_timer)
	polute_timer = Timer.new()
	polute_timer.wait_time = Config.pollute_time
	polute_timer.connect("timeout", self, "polute")
	self.add_child(polute_timer)
	
	emit_signal("hp_changed", hp, max_hp)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
onready var skill_cd_bar = $"../UILayer/SkillCDBar"
onready var soulgem_bar = $"../UILayer/SoulGem"
func _process(delta):
	skill_progress = clamp(skill_progress + delta, 0, skill_cd)
	skill_cd_bar.value = skill_progress
	skill_cd_bar.max_value = skill_cd
	#print(polution, max_polution)
	soulgem_bar.max_value = max_polution
	soulgem_bar.value = polution
	if mahoshojo_enabled and polution >= max_polution:
		GlobalState.dead_cause = "你付出了代价"
		get_tree().change_scene("res://scenes/gg_menu/GGMenu.tscn")
	
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
	if freezed:
		return 
	if atk_vec != null:
		for i in range(weapon.num):
			var b = Bullet.instance()
			var angle = atk_vec.normalized().angle() 
			var angle_u = angle + weapon.distribution / 2.0
			var angle_l = angle - weapon.distribution / 2.0
			b.velocity =  Vector2(1,0).rotated(angle_l + randf() * weapon.distribution)
			b.position = position + b.velocity * speed * 5
			b.config_bullet_with(weapon)
			b.value += extra_atk
			b.amp += extra_amp
			b.greedy += extra_greedy
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
	if freezed:
		move_and_collide(Vector2.ZERO)
	else:
		move_and_collide(velocity.normalized() * speed_scale * delta * speed)
	pass

# since we implement duck type, there's no explicit interface
# but every mob should implement this method
func attacked(damage: Damage):
	var val = clamp(damage.value - defend * (max(1 - damage.amp, 0.0)), 1.0, INF)
	if invincible:
		val = 0
	hp -= val
	if damage.freeze > 0:
		freezed = true
		buff_timer.start(damage.freeze)
	emit_signal("hp_changed", hp, max_hp)
	pass

func activate_invincible():
	invincible = true
	invincible_timer.start(Config.invincible_time)
	$"../UILayer/HpBar".modulate = Color.gold
func defreeze():
	freezed = false
func deinvincible():
	invincible = false
	$"../UILayer/HpBar".modulate = Color(1,1,1,1)
func heal():
	hp += auto_heal
	hp = clamp(hp, 0, max_hp)
	emit_signal("hp_changed", hp, max_hp)

func weapon_equip(weapon):
	atk_cd = weapon.cd
	atkcd_timer.wait_time = atk_cd
	self.weapon = weapon


var buffs := []
func buff_equip(buff):
	buff.equip_on(self)
	buffs.append(buff)
	emit_signal("hp_changed", hp, max_hp)
func buff_not_equip(buff):
	buff.equip_off(self)
	buffs.erase(buff)
	emit_signal("hp_changed", hp, max_hp)
var timed_buffs := []
func timed_buff_on(buff):
	buff.equip_on(self)
	timed_buffs.append(buff)
	get_tree().create_timer(buff.last_time).connect("timeout", buff, "equip_off")
func skill_equip(skill):
	if self.skill != null:
		skill_not_equip(self.skill)
	self.skill = skill
	self.skill_cd = skill.cd
	self.skill_progress = 0.0
	skill.equip_on(self)
	var btn = $"../UILayer/Skill"
	if skill.can_trig:
		btn.disabled = false
	btn.text = skill.get_description()
	pass
func skill_not_equip(skill):
	skill.equip_off(self)
	var btn = $"../UILayer/Skill"
	btn.disabled = true
	btn.text = "主动技能"
	pass
func trig_skill():
	if abs(skill_progress - skill_cd) < 1e-5:
		skill.on_trig(self)
		skill_progress = 0.0
