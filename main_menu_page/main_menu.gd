extends Control
class_name MainMenu

@export var initalPage := 0

@onready var buttons: HBoxContainer = %Buttons
@onready var page_container: Control = %PageContainer

const WORKOUT_A = preload("res://resrouces/workout_resources/Workout.tres")

func _ready() -> void:
	_open_page(initalPage)
	
	for button: Button in buttons.get_children():
		button.pressed.connect(_open_page.bind(button.get_index()))
	
func _open_page(pageNumber: int) -> void:
	for i in page_container.get_child_count():
		page_container.get_children()[i].visible = i == pageNumber
