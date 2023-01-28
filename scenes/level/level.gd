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
	
func gen_coin():
	var pos = $LevelMap.get_random_empty_global_pos() + Vector2(16, 16)
	var coin = preload("res://scenes/objekts/Coin.tscn").instance()
	coin.position = pos
	add_child(coin)
	pass
func go_next_level():
	var upgrade_menu = preload("res://scenes/upgrade_menu/UpgradeMenu.tscn").instance()
	$UILayer.add_child(upgrade_menu)
	get_tree().paused = true
	#$UILayer.remove_child(upgrade_menu)
	GlobalState.score += GlobalState.level * Config.score_scale
	GlobalState.level += 1
	LevelState.reset()
	for e in get_tree().get_nodes_in_group("enemy"):
		e.queue_free()
	cportal.queue_free()
	
	$UILayer/LoadingPopup.show()
	get_tree().create_timer(0.3).connect("timeout", self, "regenerate_level")
	#regenerate_level()


func game_over(hp, max_hp):
	if hp <= 0.0:
		get_tree().change_scene("res://scenes/gg_menu/GGMenu.tscn")
	
