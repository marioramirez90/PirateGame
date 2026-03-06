extends CanvasLayer

var button_rects: Dictionary = {}
var touch_actions: Dictionary = {}
var button_textures: Dictionary = {}

func _ready():
	# Buttons für alle Geräte anzeigen (Desktop und Mobile)
	_load_button_textures()
	_setup_controls()

func _load_button_textures():
	# Lade die Button-Bilder aus dem button Ordner
	button_textures["left"] = load("res://button/left.png")
	button_textures["right"] = load("res://button/right.png")
	button_textures["jump"] = load("res://button/jump.png")
	button_textures["attack"] = load("res://button/attack.png")

func _setup_controls():
	var vp_size = get_viewport().get_visible_rect().size
	var btn_size = 100.0  # Größere Buttons für bessere Sichtbarkeit
	var margin = 15.0
	var spacing = 10.0
	var bottom_y = vp_size.y - margin - btn_size

	# Left side - movement
	_add_button("ui_left", "left", Vector2(margin, bottom_y), Vector2(btn_size, btn_size))
	_add_button("ui_right", "right", Vector2(margin + btn_size + spacing, bottom_y), Vector2(btn_size, btn_size))

	# Right side - actions
	_add_button("ui_accept", "jump", Vector2(vp_size.x - margin - btn_size * 2 - spacing, bottom_y), Vector2(btn_size, btn_size))
	_add_button("ui_attack", "attack", Vector2(vp_size.x - margin - btn_size, bottom_y), Vector2(btn_size, btn_size))

func _add_button(action: String, texture_key: String, pos: Vector2, bsize: Vector2):
	# Hintergrund-Panel für bessere Sichtbarkeit
	var panel = Panel.new()
	panel.position = pos
	panel.size = bsize
	panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.1, 0.1, 0.1, 0.3)
	style.corner_radius_top_left = 10
	style.corner_radius_top_right = 10
	style.corner_radius_bottom_left = 10
	style.corner_radius_bottom_right = 10
	panel.add_theme_stylebox_override("panel", style)
	add_child(panel)
	
	# Button-Bild darüber
	var texture_rect = TextureRect.new()
	texture_rect.texture = button_textures[texture_key]
	texture_rect.position = pos
	texture_rect.size = bsize
	texture_rect.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
	texture_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	texture_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(texture_rect)

	# Touch area slightly larger than visual button
	var touch_padding = 5.0
	button_rects[action] = Rect2(
		pos - Vector2(touch_padding, touch_padding),
		bsize + Vector2(touch_padding * 2, touch_padding * 2)
	)

func _input(event: InputEvent):
	# Touch-Unterstützung für Mobile
	if event is InputEventScreenTouch:
		if event.pressed:
			var action = _get_action_at(event.position)
			if action != "":
				touch_actions[event.index] = action
				Input.action_press(action)
				get_viewport().set_input_as_handled()
		else:
			if touch_actions.has(event.index):
				Input.action_release(touch_actions[event.index])
				touch_actions.erase(event.index)
				get_viewport().set_input_as_handled()
	elif event is InputEventScreenDrag:
		var old_action = touch_actions.get(event.index, "")
		var new_action = _get_action_at(event.position)
		if old_action != new_action:
			if old_action != "":
				Input.action_release(old_action)
				touch_actions.erase(event.index)
			if new_action != "":
				touch_actions[event.index] = new_action
				Input.action_press(new_action)
			get_viewport().set_input_as_handled()
	# Maus-Unterstützung für Desktop
	elif event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				var action = _get_action_at(event.position)
				if action != "":
					touch_actions[-1] = action  # -1 für Maus
					Input.action_press(action)
					get_viewport().set_input_as_handled()
			else:
				if touch_actions.has(-1):
					Input.action_release(touch_actions[-1])
					touch_actions.erase(-1)
					get_viewport().set_input_as_handled()

func _get_action_at(pos: Vector2) -> String:
	for action in button_rects:
		if button_rects[action].has_point(pos):
			return action
	return ""
