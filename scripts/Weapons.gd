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
	func on_bullet_generated(bullet: Node2D):
		pass
class WSpark2:
	var value = 7.0
	var freeze = 0.0
	var amp = 0.0
	var distribution = PI / 6.0
	var num = 1
	var cd = 0.4
	var bullet_speed = 4.0
	var tag = 'b'
	var distance = INF
	func on_bullet_generated(bullet: Node2D):
		pass
class WSpark3:
	var value = 10.0
	var freeze = 0.0
	var amp = 0.0
	var distribution = PI / 6.0
	var num = 1
	var cd = 0.4
	var bullet_speed = 4.0
	var tag = 'b'
	var distance = INF
	func on_bullet_generated(bullet: Node2D):
		bullet.add_child(
			preload("res://scenes/widgets/SimpleLight.tscn").instance()
			)
		bullet.get_child(bullet.get_child_count() - 1).energy = 0.3
# 散射弹药
class WShock1:
	var value = 7.0
	var freeze = 0.3
	var amp = 0.0
	var distribution = PI / 3.0
	var num = 5
	var cd = 0.6
	var bullet_speed = 7.0
	var tag = 'b'
	var distance = 100
	func on_bullet_generated(bullet: Node2D):
		pass
