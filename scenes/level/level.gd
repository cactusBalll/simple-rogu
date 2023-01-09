extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	# 把角色放在一个空的位置
	var mapp = $LevelMap.mapp
	var map_size = $LevelMap.map_size
	
	$Player.position = $LevelMap.map_to_world(mapp.get_random_empty())
				
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
