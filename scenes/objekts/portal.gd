extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("body_entered", self, "on_player_entered")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func on_player_entered(body):
	if body.has_method("vjoystick_move"):
		$"..".go_next_level()
	pass
