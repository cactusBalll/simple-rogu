extends Node


var difficulty = 0
var starter = 0


func config_player_0(player):
	player.hp = 125.0
	player.max_hp = 125.0
	player.auto_heal = 2.0
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

func reset():
	score = 0
	level = 1
	difficulty = 0
	starter = 0
	coin = 0
	#map_size = 55
	
var score = 0
var level = 1

func add_score(n: int):
	score += n
	

#var map_size = 55

var coin = 0

func add_coin(n: int):
	coin += n
