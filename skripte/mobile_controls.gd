extends CanvasLayer

var button_rects: Dictionary = {}
var touch_actions: Dictionary = {}

func _ready():
	if not DisplayServer.is_touchscreen_available():
		queue_free()
		return
	_setup_controls()

func _setup_controls():
	var vp_size = get_viewport().get_visible_rect().size
	var btn_size = 70.0
	var margin = 15.0
	var spacing = 10.0
	var bottom_y = vp_size.y - margin - btn_size

	# Left side - movement
	_add_button("ui_left", "◀", Vector2(margin, bottom_y), Vector2(btn_size, btn_size))
	_add_button("ui_right", "▶", Vector2(margin + btn_size + spacing, bottom_y), Vector2(btn_size, btn_size))

	# Right side - actions
	_add_button("ui_accept", "▲", Vector2(vp_size.x - margin - btn_size * 2 - spacing, bottom_y), Vector2(btn_size, btn_size))
	_add_button("ui_attack", "⚔", Vector2(vp_size.x - margin - btn_size, bottom_y), Vector2(btn_size, btn_size))

func _add_button(action: String, label_text: String, pos: Vector2, bsize: Vector2):
	var panel = Panel.new()
	panel.position = pos
	panel.size = bsize
	panel.mouse_filter = Control.MOUSE_FILTER_IGNORE

	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.1, 0.1, 0.1, 0.5)
	style.corner_radius_top_left = 12
	style.corner_radius_top_right = 12
	style.corner_radius_bottom_left = 12
	style.corner_radius_bottom_right = 12
	style.border_width_top = 2
	style.border_width_bottom = 2
	style.border_width_left = 2
	style.border_width_right = 2
	style.border_color = Color(1, 1, 1, 0.3)
	panel.add_theme_stylebox_override("panel", style)
	add_child(panel)

	var lbl = Label.new()
	lbl.text = label_text
	lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	lbl.set_anchors_preset(Control.PRESET_FULL_RECT)
	lbl.add_theme_font_size_override("font_size", int(bsize.y * 0.45))
	lbl.add_theme_color_override("font_color", Color(1, 1, 1, 0.85))
	lbl.mouse_filter = Control.MOUSE_FILTER_IGNORE
	panel.add_child(lbl)

	# Touch area slightly larger than visual button
	var touch_padding = 5.0
	button_rects[action] = Rect2(
		pos - Vector2(touch_padding, touch_padding),
		bsize + Vector2(touch_padding * 2, touch_padding * 2)
	)

func _input(event: InputEvent):
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

func _get_action_at(pos: Vector2) -> String:
	for action in button_rects:
		if button_rects[action].has_point(pos):
			return action
	return ""
