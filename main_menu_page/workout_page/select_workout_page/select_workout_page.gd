extends Control

@onready var grid_container: GridContainer = $SaftyArea/MarginContainer/VBoxContainer/ScrollContainer/GridContainer
@onready var add_button_container: PanelContainer = $SaftyArea/MarginContainer/VBoxContainer/ScrollContainer/GridContainer/AddButtonContainer

const MAIN_MENU = preload("res://main_menu_page/main_menu.tscn")
const WORKOUT_CONTAINER = preload("uid://cj845qi18njjj")

func _ready() -> void:
	_refresh()
	
func _refresh() -> void:
	var workouts: Array[WorkoutResource] = SaveAndLoad.load_workout_resources()
	for workout: WorkoutResource in workouts:
		var workoutContainerNode: Control = WORKOUT_CONTAINER.instantiate()
		workoutContainerNode.workout = workout
		grid_container.add_child(workoutContainerNode)

	grid_container.move_child(add_button_container, workouts.size())

func _on_top_navigation_bar_previous_page() -> void:
	var mainMenu: MainMenu = MAIN_MENU.instantiate()
	
	mainMenu.initalPage = 0

	get_tree().current_scene.queue_free()
	get_tree().root.add_child(mainMenu)
	get_tree().current_scene = mainMenu


func _on_add_button_pressed() -> void:
	get_tree().change_scene_to_file("res://main_menu_page/workout_page/setting/setting_workout_page.tscn")
