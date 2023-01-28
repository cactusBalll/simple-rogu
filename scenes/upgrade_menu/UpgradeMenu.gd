extends Panel


var upgrades = {}

func _ready():
#	for i in range(10):
#		$ScrollContainer/HBoxContainer.add_child(WidgetFactory.build_upgrade_card("test",preload("res://assets/spark.png"), 5))
	for i in range(GlobalState.level):
		var buff = get_random_upgrade()
		var card = WidgetFactory.build_upgrade_card(
			"%d" % i,
			buff.pic,
			buff.get_cost(),
			buff.get_description()
		)
		$ScrollContainer/HBoxContainer.add_child(card)
		upgrades["%d" % i] = buff
		card.connect("pushed", self, "apply_upgrade")
	var player = $"../../Player"
	var weapon_upgraded = player.weapon.upgrade()
	if weapon_upgraded != null:
		var buff = Weapons.BfWeaponUpgrade.new(weapon_upgraded)
		var card = WidgetFactory.build_upgrade_card(
			"weapon",
			buff.pic,
			buff.get_cost(),
			buff.get_description()
		)
		upgrades["weapon"] = buff
		card.connect("pushed", self, "apply_upgrade")
		$ScrollContainer/HBoxContainer.add_child(card)
	$next.connect("pressed", self, "pass_upgrade")
	pass # Replace with function body.


func pass_upgrade():
	get_tree().paused = false
	queue_free()
func apply_upgrade(idx):
	# 必须被挂到固定位置
	var player = $"../../Player"
	var buff = upgrades[idx]
	player.buff_equip(buff)
	GlobalState.coin -= buff.get_cost()
	get_tree().paused = false
	queue_free()


func get_random_upgrade():
	var l = randi() % GlobalState.level + 1
	match randi() % 4:
		0: 
			return Weapons.BfAtk.new(l)
		1:
			return Weapons.BfHeal.new(l * 25)
		2:
			return Weapons.BfMaxHp.new(l * 10)
		3:
			return Weapons.BfAutoHeal.new(1.0)
