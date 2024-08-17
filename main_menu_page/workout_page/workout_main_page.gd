extends Control

var hasSetupWorkout = true

func _ready():
	%SettingButton.pressed.connect(_open_setting)
	%StartButton.pressed.connect(_start_workout)

	if not GlobalWorkout.currentWorkout:
		hasSetupWorkout = false
		%StartButton.text = "SETUP"

func _open_setting():
	get_tree().change_scene_to_file("res://main_menu_page/workout_page/setting/setting_workout_page.tscn")

func _start_workout():
	if not hasSetupWorkout: 
		_open_setting()
		return
	
	GlobalWorkout.start_workout()
	
	get_tree().change_scene_to_file("res://main_menu_page/workout_page/doWorkout/do_workout_page.tscn")
