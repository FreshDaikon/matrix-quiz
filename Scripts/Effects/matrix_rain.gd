extends Control

@export var characters := "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyzｱｲｳｴｵｶｷｸｹｺﾅﾆﾇﾈﾉ"
@export var num_columns := 80
@export var column_height := 25
@export var base_speed := 0.1

@onready var label: RichTextLabel = $RichTextLabel
var columns := []

func _ready():
	randomize()
	label.bbcode_enabled = true
	label.fit_content = false
	label.scroll_active = false
	label.visible_characters = -1
	_initialize_columns()

func _initialize_columns():
	var viewport_width = get_viewport_rect().size.x
	var char_width = 16.0
	var available_columns = int(viewport_width / char_width)
	num_columns = min(num_columns, available_columns)

	for i in range(num_columns):
		var col = {
			"x": i,
			"y": randf_range(-column_height, 0),
			"speed": base_speed * randf_range(0.5, 1.5),
			"chars": []
		}
		for j in range(column_height):
			col["chars"].append(_random_char())
		columns.append(col)

func _process(delta):
	_update_columns(delta)
	_render_columns()

func _update_columns(delta):
	var screen_height = get_viewport_rect().size.y
	for col in columns:
		col["y"] += col["speed"] * 60 * delta
		if col["y"] > screen_height / 16:
			col["y"] = randf_range(-column_height, 0)
			for j in range(column_height):
				col["chars"][j] = _random_char()

		if randi() % 8 == 0:
			col["chars"][randi() % column_height] = _random_char()

func _render_columns():
	var text_builder := ""

	for col in columns:
		for j in range(column_height):
			var fade := float(j) / column_height
			var color := _fade_color(fade, j == column_height - 1)
			text_builder += "[color=%s]%s[/color]" % [color, col["chars"][j]]
			text_builder += "\n"
		text_builder += "\n"  # gap between columns

	label.parse_bbcode(text_builder)
	#label.text_with_bbcode = text_builder

func _random_char() -> String:
	return characters[randi() % characters.length()]

func _fade_color(fade: float, is_head: bool) -> String:
	if is_head:
		# bright white head
		return "#AFAFAF"
	else:
		var g := int(255.0 * (1.0 - fade * 0.8))
		return "#00%02X00" % g
