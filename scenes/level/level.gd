extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	regenerate_level()
	$UILayer/HpBar.max_value = $Player.max_hp
	$UILayer/HpBar.value = $Player.hp
	$Player.connect("hp_changed", self, "game_over")
	$UILayer/DeveloperMenu.visible = Config.developer_mode
	GlobalState.player = weakref($Player)
	pass # Replace with function body.
func _process(delta):
	$UILayer/ScoreBoard.text = "{0}  level: {1}".format({0: GlobalState.score, 1: GlobalState.level})
	$UILayer/CoinBoard.text = "$ {0}".format({0: GlobalState.coin})
	
var cportal
func regenerate_level():
	$LevelMap.generate_level()
	# 把角色放在一个空的位置
	var mapp = $LevelMap.mapp
	var map_size = $LevelMap.map_size
	var t = mapp.get_random_empty()
	print(t)
	var pos = $LevelMap.to_global($LevelMap.map_to_world(t))
	$Player.position = pos + Vector2(16, 16)
	# 放下通关传送门
	t = mapp.get_random_empty()
	pos = $LevelMap.to_global($LevelMap.map_to_world(t)) + Vector2(16, 16)
	var portal = preload("res://scenes/objekts/portal.tscn").instance()
	portal.position = pos
	$UILayer/DeveloperMenu/VBoxContainer/gotoPortal.portal_pos = pos
	$UILayer/DeveloperMenu/VBoxContainer/portalPos.text = "portal: %.1f,%.1f"%[pos.x, pos.y]
	add_child(portal)
	cportal = portal
	
	# 生成硬币
	for i in range(20 + GlobalState.level * Config.coin_density):
		gen_coin()
	for i in range(clamp(GlobalState.level/5, 1, 5)):
		gen_chest()
	for i in range(30 - GlobalState.difficulty * 20 
			+ GlobalState.level * (Config.coin_density - GlobalState.difficulty)):
		gen_hp_portion()
func gen_coin():
	var pos = $LevelMap.get_random_empty_global_pos() + Vector2(16, 16)
	var coin = preload("res://scenes/objekts/Coin.tscn").instance()
	coin.position = pos
	coin.add_to_group("things")
	add_child(coin)
	pass
func gen_hp_portion():
	var pos = $LevelMap.get_random_empty_global_pos() + Vector2(16, 16)
	var portion = preload("res://scenes/objekts/HpPortion.tscn").instance()
	portion.value = ceil(randf() * (GlobalState.level * 2 + 10.0))
	portion.position = pos
	portion.add_to_group("things")
	add_child(portion)
	pass
func gen_chest():
	var pos = $LevelMap.get_random_empty_global_pos() + Vector2(16, 16)
	print(pos)
	var chest = preload("res://scenes/objekts/Chest.tscn").instance()
	var sk = Weapons.get_rand_skill()
	chest.containing = sk
	chest.get_node("Panel/info").text = "是否将技能替换为" + sk.get_description()
	chest.position = pos
	chest.add_to_group("things")
	add_child(chest)
func go_next_level():
	var upgrade_menu = preload("res://scenes/upgrade_menu/UpgradeMenu.tscn").instance()
	$UILayer.add_child(upgrade_menu)
	get_tree().paused = true
	#$UILayer.remove_child(upgrade_menu)
	GlobalState.score += GlobalState.level * Config.score_scale
	GlobalState.level += 1
	LevelState.reset()
	LevelState.monster_density = ceil(GlobalState.level * (100 + GlobalState.difficulty * 40))
	for e in get_tree().get_nodes_in_group("enemy"):
		e.queue_free()
	for t in get_tree().get_nodes_in_group("things"):
		t.queue_free()
	cportal.queue_free()
	
	$UILayer/LoadingPopup.show()
	get_tree().create_timer(0.3).connect("timeout", self, "regenerate_level")
	#regenerate_level()


func game_over(hp, max_hp):
	if hp <= 0.0:
		get_tree().change_scene("res://scenes/gg_menu/GGMenu.tscn")
	
