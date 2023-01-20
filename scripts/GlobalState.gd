extends Node


var difficulty = 0
var starter = 0


func config_player_0(player):
	player.hp = 125.0
	player.max_hp = 125.0
	player.weapon_equip(Weapons.WSpark1.new())
	
func config_player_1(player):
	player.hp = 50.0
	player.max_hp = 50.0
	player.weapon_equip(Weapons.WShock1.new())


func config_player(player):
	match starter:
		0:
			config_player_0(player)
		1:
			config_player_1(player)


var score = 0
var level = 1
