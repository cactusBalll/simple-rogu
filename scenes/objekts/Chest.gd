extends Area2D

var containing = null
func _ready():
	self.connect("body_entered", self, "on_player_entered")
	self.connect("body_exited", self, "on_player_exit")
	$Panel/action.connect("act", self, "on_dialog_confirmed")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func on_player_entered(body):
	if body.has_method("vjoystick_move"):
		$Panel.visible = true
	pass
func on_player_exit(body):
	if body.has_method("vjoystick_move"):
		$Panel.visible = false
	pass
func on_dialog_confirmed(ok):
	if ok:
		if containing.has_method("on_trig"):
			GlobalState.player.get_ref().skill_equip(containing)
		elif containing.has_method("on_bullet_generated"):
			GlobalState.player.get_ref().weapon_equip(containing)
	queue_free()
