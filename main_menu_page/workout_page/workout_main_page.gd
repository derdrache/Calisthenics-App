extends Control

@onready var start_button: Button = %StartButton
@onready var setting_button: Button = %SettingButton


var hasSetupWorkout := true

func _ready() -> void:
	setting_button.pressed.connect(_open_setting)
	start_button.pressed.connect(_start_workout)

	if not GlobalWorkout.currentWorkout:
		hasSetupWorkout = false
		start_button.text = "SETUP"

func _open_setting() -> void:
	get_tree().change_scene_to_file("res://main_menu_page/workout_page/setting/setting_workout_page.tscn")

func _start_workout() -> void:
	if not hasSetupWorkout: 
		_open_setting()
		return
	
	GlobalWorkout.start_workout()
	
	get_tree().change_scene_to_file("res://main_menu_page/workout_page/doWorkout/do_workout_page.tscn")
