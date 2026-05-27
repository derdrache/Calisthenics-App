extends Control

@onready var start_button: Button = %StartButton
@onready var setting_button: Button = %SettingButton
@onready var popup_window: Control = $PopupWindow

var hasSetupWorkout := true

func _ready() -> void:
	setting_button.pressed.connect(_open_setting)
	start_button.pressed.connect(_start_workout)

	if SaveAndLoad.load_workout_resources().is_empty():
		hasSetupWorkout = false
		start_button.text = "SETUP"

func _open_setting() -> void:
	get_tree().change_scene_to_file("res://main_menu_page/workout_page/select_workout_page/select_workout_page.tscn")

func _start_workout() -> void:
	var workoutCollection := SaveAndLoad.load_workout_collection()
	var selectedWorkout := workoutCollection.get_workout(Time.get_date_dict_from_system())
	
	if not selectedWorkout: 
		popup_window.show()
		return
	
	WorkoutManager.start_workout(selectedWorkout)
	
	get_tree().change_scene_to_file("res://main_menu_page/workout_page/doWorkout/do_workout_page.tscn")
