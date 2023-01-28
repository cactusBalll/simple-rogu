extends Node




func build_upgrade_card(idx: String, texture: Texture, cost: int, description: String):
	var ret := preload("res://scenes/upgrade_menu/UpGradeItem.tscn").instance()
	ret.get_node("TextureRect").texture = texture
	ret.get_node("Button").text = "%d" % cost
	if GlobalState.coin < cost:
		var btn = ret.get_node("Button")
		btn.add_color_override("font_color_disabled", Color(1, 0.5, 0))
		btn.disabled = true
	else:
		var btn = ret.get_node("Button")
		btn.add_color_override("font_color", Color(0.1, 0.8, 0))
	ret.get_node("Decription").text = description
	ret.idx = idx
	return ret
