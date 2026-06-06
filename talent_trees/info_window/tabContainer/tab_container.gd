@tool
extends PanelContainer

signal selected(index: int)

@export var title: String = "Title":
	set(value):
		title = value
		if is_node_ready():
			label.text = value

@export_category("Custom")
@export var selectedStyleBox: StyleBox
@export var unselectedStyleBox: StyleBox

@onready var label: Label = $Label

func _ready() -> void:
	label.text = title

func set_select(boolean: bool) -> void:
	if boolean:
		add_theme_stylebox_override("panel", selectedStyleBox)
	else:
		add_theme_stylebox_override("panel", unselectedStyleBox)


func _on_button_pressed() -> void:
	selected.emit(get_index())
