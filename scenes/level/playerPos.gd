extends Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
onready var player := $"../../../../Player"
func _process(delta):
	text = "player: %.1f,%.1f" % [player.position.x, player.position.y]
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
