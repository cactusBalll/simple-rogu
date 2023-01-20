extends Button


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("pressed", self, "on_button_pressed")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

onready var levelMap := $"../../../../LevelMap"
onready var player := $"../../../../Player"
onready var loadingPopup = $"../../../LoadingPopup"
func on_button_pressed():
	loadingPopup.show()
	# work around just, 异步不会，线程同步也忘了
	get_tree().create_timer(0.5).connect("timeout",self, "exec_gen_level")

func exec_gen_level():
	levelMap.generate_level()
	var mapp = levelMap.mapp
	var map_size = levelMap.map_size
	var t = mapp.get_random_empty()
	print(t)
	var pos = levelMap.to_global(levelMap.map_to_world(t))
	player.position = pos + Vector2(16, 16)
