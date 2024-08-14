extends Control

func _ready():
	%SettingButton.pressed.connect(_open_setting)


func _open_setting():
	get_tree().change_scene_to_file("res://main_menu_page/workout_page/setting/setting_workout_page.tscn")
