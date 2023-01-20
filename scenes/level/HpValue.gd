extends Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var player := $"../../Player"
# Called when the node enters the scene tree for the first time.
func _ready():
	player.connect("hp_changed", self, "on_hp_changed")
	text = "%.0f / %.0f" % [player.hp, player.max_hp]
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func on_hp_changed(hp, max_hp):
	text = "%.0f / %.0f" % [hp, max_hp]
