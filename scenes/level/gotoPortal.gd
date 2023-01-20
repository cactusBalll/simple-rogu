extends Button


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("pressed", self, "on_pressed")
	pass # Replace with function body.



onready var player := $"../../../../Player"
var portal_pos: Vector2
func on_pressed():
	player.position = portal_pos + Vector2(20,20)
