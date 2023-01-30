extends Area2D


func _ready():
	self.connect("body_entered", self, "on_player_entered")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func on_player_entered(body):
	#print("entering madoka")
	if body.has_method("vjoystick_move"):
		var dialog = Dialogic.start("endness")
		dialog.connect("dialogic_signal", DialogSigDispatcher, "dispatch_signal")
		dialog.pause_mode = PAUSE_MODE_PROCESS
		dialog.connect("timeline_end", self, "_on_end_timeline")
		get_tree().paused = true
		add_child(dialog)
	pass

func _on_end_timeline(_timeline_name):
	get_tree().paused = false
	queue_free()
