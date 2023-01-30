extends Area2D


# 范围效果区域

var effect: FuncRef = null
func _ready():
	$Timer.connect("timeout", self, "queue_free")
	$EffectTimer.connect("timeout", self, "effect_activate")
	$Timer.start()
	$EffectTimer.start()
func effect_activate():
	#print("activate")
	effect.call_func(get_overlapping_bodies())
	pass


func config(active_time, interval, effect_callback: FuncRef, sprite: Texture):
	$Timer.wait_time = active_time
	$EffectTimer.wait_time = interval
	effect = effect_callback
	$Sprite.texture = sprite
	
