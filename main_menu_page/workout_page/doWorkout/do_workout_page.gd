extends Control

@onready var continue_button = %ContinueButton


var currentExcercises = GlobalWorkout.get_current_exercise()
var isWorkoutDone = GlobalWorkout.is_workout_done()
var repsDone

func _ready():
	%SelectionCarusel.valueChanged.connect(_set_reps_done)
	continue_button.pressed.connect(_next_step)
	
	repsDone = %SelectionCarusel.initialValue
	%CurrentExerciseLabel.text = currentExcercises.talent.get_talent_name()
	
	%GoalLabel.text = "GOAL: " + str(currentExcercises.reps) + " Reps"
	
	var currentSet = GlobalWorkout.get_current_set()
	var maxSet = GlobalWorkout.get_current_max_set()
	%SetInformationLabel.text = "Set: " + str(currentSet) + " / " + str(maxSet)
	
	if isWorkoutDone: continue_button.text = "DONE"

func _set_reps_done(value):
	repsDone = value

func _next_step():
	GlobalWorkout.next_exersice(int(repsDone))
	if isWorkoutDone:
		get_tree().change_scene_to_file("res://main_menu_page/workout_page/workoutResultPage/workout_result_page.tscn")
	else:
		get_tree().change_scene_to_file("res://main_menu_page/workout_page/doWorkout/break_page.tscn")
	
