extends Control

@onready var continue_button: Button = %ContinueButton
@onready var selection_carusel: Control = %SelectionCarusel
@onready var current_exercise_label: Label = %CurrentExerciseLabel
@onready var set_information_label: Label = %SetInformationLabel
@onready var goal_label: Label = %GoalLabel


var currentExcercises := WorkoutManager.get_current_exercise()
var isWorkoutDone := WorkoutManager.is_workout_done()

func _ready() -> void:
	continue_button.pressed.connect(_next_step)
	
	selection_carusel.initialValue = currentExcercises.reps
	
	current_exercise_label.text = currentExcercises.talent.get_talent_name()
	
	goal_label.text = "GOAL: " + str(currentExcercises.reps) + " Reps"
	
	var currentSet := WorkoutManager.get_current_set()
	var maxSet := WorkoutManager.get_current_max_set()
	set_information_label.text = "Set: " + str(currentSet) + " / " + str(maxSet)
	
	if isWorkoutDone: continue_button.text = "DONE"


func _next_step() -> void:
	var repsDone: int = int(selection_carusel.get_selected_value())
	
	if not repsDone: await get_tree().create_timer(0.5)
	
	WorkoutManager.set_next_exersice(int(repsDone))
	
	if isWorkoutDone:
		get_tree().change_scene_to_file("res://main_menu_page/workout_page/workoutResultPage/workout_result_page.tscn")
	else:
		get_tree().change_scene_to_file("res://main_menu_page/workout_page/doWorkout/break_page.tscn")
	
