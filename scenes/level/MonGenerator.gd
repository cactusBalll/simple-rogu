extends Timer

# 怪物生成
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var cnt := 0 # 生成计数器
var is_gen_slime := true


var slime := preload("res://scenes/level/MonSlime.tscn")


onready var levelMap = $"../LevelMap"
onready var player = $"../Player"
onready var level = $".."
export var safe_distance = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("timeout", self, "gen_monster")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func get_random_pos() -> Vector2:
	var pos = levelMap.get_random_empty_global_pos()
	while (pos-player.position).length() < safe_distance:
		pos = levelMap.get_random_empty_global_pos()
	return pos	
	
func gen_monster():
	if LevelState.current_monster_density < LevelState.monster_density * 0.5:
		for i in range(20): # 快速生成依托敌人提高敌人密度
			exec_gen_monster()
	else:
		exec_gen_monster()
func exec_gen_monster():
	if is_gen_slime:
		if LevelState.current_monster_density >= LevelState.monster_density:
			return
		LevelState.current_monster_density += 1
		var pos = get_random_pos()
		var sl = slime.instance()
		sl.add_to_group("enemy")
		sl.player = player
		sl.position = pos
		level.add_child(sl)	
