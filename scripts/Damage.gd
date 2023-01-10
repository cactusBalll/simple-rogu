extends Node

class_name Damage

export var value := 0.0
export var freeze := 0.0
export var amp := 0.0


func _init(value_, freeze_, amp_):
	self.value = value_
	self.freeze = freeze_
	self.amp = amp_
