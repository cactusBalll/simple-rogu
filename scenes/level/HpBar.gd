extends TextureProgress


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var player := $"../../Player"
# Called when the node enters the scene tree for the first time.
func _ready():
	player.connect("hp_changed", self, "on_hp_changed")
	value = player.hp
	max_value = player.max_hp
	pass # Replace with function body.

func on_hp_changed(hp, max_hp):
	value = hp
	max_value = max_hp

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
