extends HBoxContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal act(ok)

# Called when the node enters the scene tree for the first time.
func _ready():
	$confirm.connect("pressed", self, "confirm")
	$cancel.connect("pressed", self, "cancel")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func confirm():
	emit_signal("act", true)
	$"../..".hide()
func cancel():
	emit_signal("act", false)
	$"../..".hide()
