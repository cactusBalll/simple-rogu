extends Area2D

var value = 10.0
func _ready():
	self.connect("body_entered", self, "on_player_entered")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func on_player_entered(body):
	if body.has_method("vjoystick_move"):
		body.hp = clamp(body.hp + value, 0, body.max_hp)
		body.emit_signal("hp_changed", body.hp, body.max_hp)
		queue_free()
	pass
