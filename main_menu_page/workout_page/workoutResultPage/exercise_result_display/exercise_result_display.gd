extends HBoxContainer

const SET_DISPLAY = preload("res://main_menu_page/workout_page/workoutResultPage/exercise_result_display/set_display.tscn")

var exercise : TalentResource
var repsDoneList : Array

func _ready():
	%ExerciseNameLabel.text = exercise.get_talent_name()
	
	for reps in repsDoneList:
		var displayNode = SET_DISPLAY.instantiate()
		displayNode.reps = reps
		displayNode.goal = exercise.goal
	
		%DisplayContainer.add_child(displayNode)
