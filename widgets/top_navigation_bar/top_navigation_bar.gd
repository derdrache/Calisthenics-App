extends Control

signal previousPage
signal closePage

@export var title: String
@export var titleFontSize : int

@onready var titleNode = %title


func _ready():
	%BackButton.pressed.connect(_back_button_pressed)
	%CloseButton.pressed.connect(_close_button_pressed)
	
	%CloseButtonContainer.hide()
	
	titleNode.text = title

func _back_button_pressed():
	previousPage.emit()

func _close_button_pressed():
	closePage.emit()

func change_title(newTitle, fontSize = 0):
	titleNode.text = newTitle
	
	if fontSize: 
		titleNode.add_theme_font_size_override("font_size", fontSize)

func hide_back_button():
	%BackButtonContainer.hide()
	
func show_close_button():
	%CloseButtonContainer.show()
