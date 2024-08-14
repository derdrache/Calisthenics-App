extends Control

const MAIN_MENU = preload("res://main_menu_page/main_menu.tscn")	

func _on_top_navigation_bar_previous_page():
	var mainMenu = MAIN_MENU.instantiate()
	
	mainMenu.initalPage = 0

	get_tree().current_scene.queue_free()
	get_tree().root.add_child(mainMenu)
	get_tree().current_scene = mainMenu

func _get_all_workout_data():
	pass


func _on_button_pressed():
	var workoutData = _get_all_workout_data()
	
