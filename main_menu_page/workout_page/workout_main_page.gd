extends Control

func _ready():
	%SettingButton.pressed.connect(_open_setting)
	%StartButton.pressed.connect(_start_workout)

func _open_setting():
	get_tree().change_scene_to_file("res://main_menu_page/workout_page/setting/setting_workout_page.tscn")

func _start_workout():
	GlobalWorkout.start_workout()
	
	get_tree().change_scene_to_file("res://main_menu_page/workout_page/doWorkout/do_workout_page.tscn")
