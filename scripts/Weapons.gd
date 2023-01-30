extends Node
class_name Weapons

class Weapon:
	var value = 5.0
	var freeze = 0.0
	var amp = 0.0
	var distribution = PI / 6.0
	var num = 1
	var cd = 0.4
	var bullet_speed = 4.0
	var tag = 'b'
	func _init(value, freeze, amp, distribution, num, cd ,bullet_speed):
		self.value = value
		self.freeze = freeze
		self.amp = amp
		self.distribution = distribution
		self.num = num
		self.bullet_speed = bullet_speed
	func on_bullet_generated(bullet: Node2D): # virtual
		pass

class CustomWeapon:
	func on_fire(level: Node2D): # virtual
		pass
	func get_atkcd() -> float: # virtual
		return 1.0
### 武器
# 火花，noita 原价80，打折40，推荐
class WSpark1:
	var value = 5.0
	var freeze = 0.0
	var amp = 0.0
	var distribution = PI / 6.0
	var num = 1
	var cd = 0.4
	var bullet_speed = 4.0
	var tag = 'b'
	var distance = INF
	func get_description():
		return "火花1"
	func on_bullet_generated(bullet: Node2D):
		pass
	func upgrade():
		return WSpark2.new()
class WSpark2:
	var value = 7.0
	var freeze = 0.0
	var amp = 0.0
	var distribution = PI / 12.0
	var num = 1
	var cd = 0.4
	var bullet_speed = 4.0
	var tag = 'b'
	var distance = INF
	func get_description():
		return "火花2"
	func on_bullet_generated(bullet: Node2D):
		pass
	func upgrade():
		return WSpark3.new()
class WSpark3:
	var value = 10.0
	var freeze = 0.0
	var amp = 0.0
	var distribution = PI / 18.0
	var num = 1
	var cd = 0.4
	var bullet_speed = 4.0
	var tag = 'b'
	var distance = INF
	func get_description():
		return "火花3"
	func on_bullet_generated(bullet: Node2D):
		bullet.add_child(
			preload("res://scenes/widgets/SimpleLight.tscn").instance()
			)
		bullet.get_child(bullet.get_child_count() - 1).energy = 0.3
	func upgrade():
		return null
# 散射弹药
class WShock1:
	var value = 3.0
	var freeze = 0.3
	var amp = 0.0
	var distribution = PI / 3.0
	var num = 5
	var cd = 0.6
	var bullet_speed = 7.0
	var tag = 'b'
	var distance = 100
	func get_description():
		return "散弹1"
	func on_bullet_generated(bullet: Node2D):
		pass
	func upgrade():
		return WShock2.new()

class WShock2:
	var value = 4.0
	var freeze = 0.3
	var amp = 0.0
	var distribution = PI / 3.0
	var num = 7
	var cd = 0.6
	var bullet_speed = 7.0
	var tag = 'b'
	var distance = 100
	func get_description():
		return "散弹2"
	func on_bullet_generated(bullet: Node2D):
		pass
	func upgrade():
		return WShock3.new()

class WShock3:
	var value = 4.0
	var freeze = 0.3
	var amp = 0.0
	var distribution = PI / 3.0
	var num = 9
	var cd = 0.6
	var bullet_speed = 7.0
	var tag = 'b'
	var distance = 120
	func get_description():
		return "散弹3"
	func on_bullet_generated(bullet: Node2D):
		pass
	func upgrade():
		return null
# 高能单发弹药	
class WShot1:
	var value = 10.0
	var freeze = 0.6
	var amp = 0.0
	var distribution = 0.0
	var num = 1
	var cd = 1.8
	var bullet_speed = 12.0
	var tag = 'b'
	var distance = INF
	func get_description():
		return "穿凿1"
	func on_bullet_generated(bullet: Node2D):
		#bullet.get_node("Sprite").texture = preload("res://assets/particle/rred.png")
		bullet.add_child(preload("res://scenes/widgets/MeParticle.tscn").instance())
	func upgrade():
		return WShot2.new()

class WShot2:
	var value = 15.0
	var freeze = 0.6
	var amp = 0.0
	var distribution = 0.0
	var num = 1
	var cd = 1.4
	var bullet_speed = 12.0
	var tag = 'b'
	var distance = INF
	func get_description():
		return "穿凿2"
	func on_bullet_generated(bullet: Node2D):
		bullet.add_child(preload("res://scenes/widgets/MeParticle.tscn").instance())
	func upgrade():
		return WShot3.new()

class WShot3:
	var value = 20.0
	var freeze = 0.6
	var amp = 0.0
	var distribution = 0.0
	var num = 1
	var cd = 1.0
	var bullet_speed = 12.0
	var tag = 'b'
	var distance = INF
	func get_description():
		return "穿凿3"
	func on_bullet_generated(bullet: Node2D):
		bullet.add_child(preload("res://scenes/widgets/MeParticle.tscn").instance())
	func upgrade():
		return null
		
# 简单装备类
class SimpleBuff:
	func equip_on(player):
		pass
	func equip_off(player):
		pass
	func get_description():
		return ""
	func get_cost():
		return 0

class BfAtk:
	var value = 1.0
	var pic := preload("res://assets/spark.png")
	func _init(value):
		self.value = value
	func equip_on(player):
		player.extra_atk += value
	func equip_off(player):
		player.extra_atk -= value
	func get_description():
		return "额外攻击力增加%.0f" % value
	func get_cost():
		return (value * 10) as int
class BfHeal:
	var value = 25.0
	var pic := preload("res://assets/spark.png")
	func _init(value):
		self.value = value
	func equip_on(player):
		player.hp = clamp(player.hp + value, 0, player.max_hp)
	func equip_off(player):
		pass
	func get_description():
		return "恢复生命值%.0f" % value
	func get_cost():
		return (value / 2) as int
class BfMaxHp:
	var value = 10.0
	var pic := preload("res://assets/spark.png")
	func _init(value):
		self.value = value
	func equip_on(player):
		player.max_hp += value
	func equip_off(player):
		player.max_hp -= value
	func get_description():
		return "最大生命值增加%.0f(不恢复)" % value
	func get_cost():
		return (value * 2) as int

class BfWeaponUpgrade:
	var weapon
	var pic := preload("res://assets/spark.png")
	func _init(weapon):
		self.weapon = weapon
	func equip_on(player):
		player.weapon_equip(weapon)
	func equip_off(player):
		pass
	func get_description():
		return "升级当前装备"
	func get_cost():
		return 100

class BfAutoHeal:
	var value = 1.0
	var pic := preload("res://assets/spark.png")
	func _init(value):
		self.value = value
	func equip_on(player):
		player.auto_heal += value
	func equip_off(player):
		player.auto_heal -= value
	func get_description():
		return "每%.1f恢复%.0f生命值" % [Config.heal_time, value]
	func get_cost():
		return (value * 20) as int

class BfGreedy:
	var value = 1.0
	var pic := preload("res://assets/spark.png")
	func _init(value):
		self.value = value
	func equip_on(player):
		player.extra_greedy += value
	func equip_off(player):
		player.extra_greedy -= value
	func get_description():
		return "添加%.0f点吸血" % [value]
	func get_cost():
		return (value * 50) as int
# 主动技能

static func get_rand_skill():
	var l = randi() % GlobalState.level + 1
	match randi() % 7:
		0:
			return SkTorch.new()
		1:
			return SkHeal.new(l * 20.0)
		2:
			return SkInvincible.new()
		3:
			return SkHeavyArmor.new()
		4:
			return SkGreedy.new()
		5:
			return SkPredict.new()
		6:
			return SkFlareZone.new(l)
class SkTorch:
	var cd = 20.0
	var can_trig = true
	func on_trig(player):
		var torch = preload("res://scenes/objekts/Torch.tscn").instance()
		torch.position = player.position
		player.get_parent().add_child(torch)
	func get_description():
		return "火把"
	func equip_on(player):
		pass
	func equip_off(player):
		pass

class SkHeal:
	var value = 20.0
	var cd = 15.0
	var can_trig = true
	func _init(value):
		self.value = value
	func on_trig(player):
		player.hp = clamp(player.hp + value, 0, player.max_hp)
		player.emit_signal("hp_changed", player.hp, player.max_hp)
	func get_description():
		return "治疗术+%.0f"%value
	func equip_on(player):
		pass
	func equip_off(player):
		pass

class SkInvincible:
	var cd = 60.0
	var can_trig = true
	func on_trig(player):
		player.activate_invincible()
	func get_description():
		return "无敌1s"
	func equip_on(player):
		pass
	func equip_off(player):
		pass

class SkHeavyArmor:
	var cd = 0.0
	var can_trig = false
	func on_trig(player):
		pass
	func get_description():
		return "重甲(高额减伤但移速减慢)"
	func equip_on(player):
		player.defend += 20
		player.speed -= 1
	func equip_off(player):
		player.defend -= 20
		player.speed += 1

class SkGreedy:
	var cd = 10.0
	var can_trig = true
	func on_trig(player):
		player.hp = clamp(player.hp + 10.0, 0, player.max_hp)
		player.emit_signal("hp_changed", player.hp, player.max_hp)
	func get_description():
		return "吸血+1(被动)，治疗术+10.0"
	func equip_on(player):
		player.extra_greedy += 1.0
	func equip_off(player):
		player.extra_greedy -= 1.0

class SkPredict:
	var cd = 10.0
	var can_trig = true
	func on_trig(player):
		var direct = preload("res://scenes/widgets/MeParticle.tscn").instance()
		var b = preload("res://scenes/castspells/PlayerBullet.tscn").instance()
		b.value = 0.0
		b.speed = 1.0
		b.add_child(direct)
		var player_pos = GlobalState.player.get_ref().position
		var vec: Vector2 = (LevelState.portal_pos-player_pos).normalized()
		b.position = vec * 30.0 + player_pos
		b.velocity = vec
		GlobalState.player.get_ref().get_node("..").add_child(b)
	func get_description():
		return "最大生命+25(被动),感知传送门方向"
	func equip_on(player):
		player.max_hp += 25.0
	func equip_off(player):
		player.max_hp -= 25.0


class SkFlareZone:
	var cd setget ,_get_cd
	var can_trig = true
	var value = 1.0
	func _init(value):
		self.value = value
	func _get_cd():
		return value * 30.0
	func on_trig(player):
		var player_pos = GlobalState.player.get_ref().position
		for i in range(-3, 4):
			for j in range(-3,4):
				if i != 0 or j != 0:
					var zone = preload("res://scenes/buff_zones/BuffZone.tscn").instance()
					zone.config(
						3.0,
						0.5,
						funcref(self, "_effect_callback"),
						preload("res://assets/flare.png")
					)
					zone.add_child(preload("res://scenes/widgets/FlareParticle.tscn").instance())
					zone.position = player_pos + Vector2(i * Config.bufzone_size, j * Config.bufzone_size)
					GlobalState.levelSc.get_ref().add_child(zone)
	func get_description():
		return "生成火焰区域:%.0f" % value
	func equip_on(player):
		pass
	func equip_off(player):
		pass
	
	func _effect_callback(bodys: Array):
		#print(bodys)
		for body in bodys:
			if not body.has_method("vjoystick_move"):
				body.attacked(Damage.new(value, 0.0, 0.0))


# Timed Buff
class TBMaho:
	var last_time = 60.0
	var player
	var particle
	func timed_buff():
		pass
	func equip_on(player):
		self.player = player
		player.extra_atk += 20.0
		player.defend += 40.0
		player.extra_amp += 1.0
		self.particle = preload("res://scenes/widgets/PinkParticle.tscn").instance()
		player.add_child(particle)
	func equip_off():
		print("called")
		player.extra_atk -= 20.0
		player.defend -= 40.0
		player.extra_amp -= 1.0
		player.remove_child(particle)
		
		player.timed_buffs.erase(self)
