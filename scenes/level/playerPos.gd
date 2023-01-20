extends Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
onready var player := $"../../../../Player"
func _process(delta):
	text = "player: {0}".format({0:player.position})
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
