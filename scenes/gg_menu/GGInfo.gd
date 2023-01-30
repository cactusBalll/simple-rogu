extends Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const info = [
	"游戏结束",
	"寄",
	"蔡",
	"那么战败CG什么的有在做吗",
	"想啊，很想啊"
]

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	if GlobalState.dead_cause == null:
		text = info[randi() % info.size()]
	else:
		text = GlobalState.dead_cause
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
