extends Button


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


func _ready():
	self.connect("pressed", self, "on_pressed")
	pass # Replace with function body.



onready var player := $"../../../../Player"
func on_pressed():
	player.hp = 0.0
	player.emit_signal("hp_changed", player.hp, player.max_hp)
