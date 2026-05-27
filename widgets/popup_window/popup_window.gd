@tool
extends Control

@export var title: String = "":
	set(value):
		title = value
		
		if is_node_ready():
			%titleLabel.text = value
@export_multiline var description: String = "":
	set(value):
		description = value
		if is_node_ready():
			%descriptionLabel.text = value

func _ready() -> void:
	hide()

func _on_close_button_pressed() -> void:
	hide()
