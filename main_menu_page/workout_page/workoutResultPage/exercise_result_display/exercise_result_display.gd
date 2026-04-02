extends HBoxContainer
class_name ExerciseResultDisplay

@onready var exercise_name_label: Label = %ExerciseNameLabel
@onready var display_container: VBoxContainer = %DisplayContainer

const SET_DISPLAY = preload("res://main_menu_page/workout_page/workoutResultPage/exercise_result_display/set_display.tscn")

@export var exercise : Exercise

func _ready() -> void:
	exercise_name_label.text = exercise.talent.get_talent_name()
	
	for reps: int in exercise.repsDone:
		var displayNode: ExerciseDoneDisplay = SET_DISPLAY.instantiate()
		displayNode.reps = reps
		displayNode.goal = exercise.reps
	
		display_container.add_child(displayNode)
