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
	var pos = levelMap.map_to_world(levelMap.mapp.get_random_empty())
	while (pos-player.position).length() < safe_distance:
		pos = levelMap.map_to_world(levelMap.mapp.get_random_empty())
	return pos	
func gen_monster():
	if is_gen_slime:
		var pos = get_random_pos()
		var sl = slime.instance()
		sl.player = player
		sl.position = pos
		level.add_child(sl)

		