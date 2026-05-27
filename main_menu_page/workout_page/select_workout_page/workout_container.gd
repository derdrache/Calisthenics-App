extends Control

@export var workout: WorkoutResource

@onready var workout_name_label: Label = %workoutNameLabel

const SETTING_WORKOUT_PAGE = preload("uid://burqvpdk5h6cn")

func _ready() -> void:
	workout_name_label.text = workout.workoutName

func _on_button_pressed() -> void:
	var settingPageNode := SETTING_WORKOUT_PAGE.instantiate()
	settingPageNode.selectedWorkout = workout
	get_tree().change_scene_to_node(settingPageNode)

func _on_close_button_pressed() -> void:
	var fileName := workout.id + ".tres"
	SaveAndLoad.delete_file(GlobalData.SAVE_WORKOUT_PATH, fileName)
	
	queue_free()
