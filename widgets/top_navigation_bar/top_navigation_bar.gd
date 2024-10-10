extends Control
class_name TopNavigationBar

signal previousPage
signal closePage

@export var title: String
@export var titleFontSize : int

@onready var titleNode: Label = %title
@onready var back_button: Button = %BackButton
@onready var close_button: Button = %CloseButton
@onready var back_button_container: MarginContainer = %BackButtonContainer
@onready var close_button_container: MarginContainer = %CloseButtonContainer



func _ready() -> void:
	back_button.pressed.connect(_back_button_pressed)
	close_button.pressed.connect(_close_button_pressed)
	
	close_button_container.hide()
	
	titleNode.text = title

func _back_button_pressed() -> void:
	previousPage.emit()

func _close_button_pressed() -> void:
	closePage.emit()

func change_title(newTitle: String, fontSize := 0) -> void:
	titleNode.text = newTitle
	
	if fontSize: 
		titleNode.add_theme_font_size_override("font_size", fontSize)

func hide_back_button() -> void:
	back_button_container.hide()
	
func show_close_button() -> void:
	close_button_container.show()
