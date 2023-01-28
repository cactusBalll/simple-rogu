extends Panel


signal pushed(idx)
var idx: String = ""

func _ready():
	$Button.connect("pressed", self, "on_button_pressed")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func on_button_pressed():
	emit_signal("pushed", idx)
