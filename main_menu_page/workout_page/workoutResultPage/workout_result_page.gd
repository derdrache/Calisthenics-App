extends Control

@onready var workout_time_label: Label = %WorkoutTimeLabel
@onready var exercise_result_container: VBoxContainer = %ExerciseResultContainer
@onready var finish_button: Button = %FinishButton

const EXERSICE_RESULT_DISPLAY = preload("res://main_menu_page/workout_page/workoutResultPage/exercise_result_display/exercise_result_display.tscn")

var workoutExercisesData := GlobalWorkout.exerciseData

func _ready() -> void:
	finish_button.pressed.connect(_quit_page)
	
	GlobalWorkout.workout_done()
	
	_setup_workout_time()
	_setup_exercise_resulst()

func _setup_workout_time() -> void:
	if GlobalWorkout.startTime == null:
		print("Debugmode - workout_done")
		GlobalWorkout.startTime = { "hour": 12, "minute": 34, "second": 46 }
	
	var currentTime := Time.get_unix_time_from_datetime_dict(Time.get_time_dict_from_system())  
	var workoutStart := Time.get_unix_time_from_datetime_dict(GlobalWorkout.startTime)

	workout_time_label.text = "TIME: " +  GlobalData.seconds_in_minutes_string(currentTime - workoutStart)

func _setup_exercise_resulst() -> void:
	for exercise: Exercise in workoutExercisesData:
		var exersiceResultDisplayNode: ExerciseResultDisplay = EXERSICE_RESULT_DISPLAY.instantiate()
		
		exersiceResultDisplayNode.exercise = exercise.talent
		exersiceResultDisplayNode.repsDoneList = exercise.repsDone

		exercise_result_container.add_child(exersiceResultDisplayNode)	

func _quit_page() -> void:
	get_tree().change_scene_to_file("res://main_menu_page/main_menu.tscn")
