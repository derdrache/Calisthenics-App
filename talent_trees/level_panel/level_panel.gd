@tool
extends Panel

@export var title: String:
	set(value):
		title = value
		%titleLabel.text = value
@export var panelColor: Color:
	set(value):
		panelColor = value
		get_theme_stylebox("panel").bg_color = value
