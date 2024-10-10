extends HBoxContainer
class_name ExerciseResultDisplay

@onready var exercise_name_label: Label = %ExerciseNameLabel
@onready var display_container: VBoxContainer = %DisplayContainer

const SET_DISPLAY = preload("res://main_menu_page/workout_page/workoutResultPage/exercise_result_display/set_display.tscn")

var exercise : TalentResource
var repsDoneList : Array[int]

func _ready() -> void:
	exercise_name_label.text = exercise.get_talent_name()
	
	for reps: int in repsDoneList:
		var displayNode: ExerciseDoneDisplay = SET_DISPLAY.instantiate()
		displayNode.reps = reps
		displayNode.goal = exercise.goal
	
		display_container.add_child(displayNode)
