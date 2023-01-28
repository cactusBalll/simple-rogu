extends Area2D


func _ready():
	self.connect("body_entered", self, "on_player_entered")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func on_player_entered(body):
	if body.has_method("vjoystick_move"):
		GlobalState.add_coin(1)
		queue_free()
	pass
