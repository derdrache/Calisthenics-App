extends Control

@onready var popup_menu: PopupMenu = %PopupMenu



func _ready() -> void:
	popup_menu.add_item("Undo")
	popup_menu.add_item("Discard Workout")


func _on_popup_button_pressed() -> void:
	var mousePosition := get_global_mouse_position()
	popup_menu.show()
	popup_menu.position = Vector2(mousePosition.x - popup_menu.size.x, mousePosition.y)
	
func _on_popup_menu_id_pressed(id: int) -> void:
	if id == 0: _workout_undo()
	elif id == 1: _discard_workout()


func _workout_undo() -> void:
	WorkoutManager.set_previous_exercise(get_tree().current_scene.name)
	
func _discard_workout() -> void:
	get_tree().change_scene_to_file("res://main_menu_page/main_menu.tscn")
