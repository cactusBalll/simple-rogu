extends Button


func _ready():
	self.connect("pressed", self, "on_pressed")
	pass # Replace with function body.



func on_pressed():
	GlobalState.coin += 9999
