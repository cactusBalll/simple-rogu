extends Button

func _ready():
	self.connect("pressed", self, "on_pressed")
	pass # Replace with function body.


onready var player := $"../../../../Player"

func on_pressed():
	player.skill_progress = player.skill_cd
