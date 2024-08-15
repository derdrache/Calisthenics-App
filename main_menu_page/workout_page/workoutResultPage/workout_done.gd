extends Control

const EXERSICE_RESULT_DISPLAY = preload("res://main_menu_page/workout_page/workoutResultPage/exercise_result_display/exercise_result_display.tscn")

var workout = GlobalWorkout.currentWorkout

func _ready():
	%FinishButton.pressed.connect(_quit_page)
	
	_setup_workout_time()
	_setup_exercise_resulst()

func _setup_workout_time():
	if GlobalWorkout.startTime == null:
		print("Debugmode - workout_done")
		GlobalWorkout.startTime = { "hour": 12, "minute": 34, "second": 46 }
	
	var currentTime = Time.get_unix_time_from_datetime_dict(Time.get_time_dict_from_system())  
	var workoutStart = Time.get_unix_time_from_datetime_dict(GlobalWorkout.startTime)

	%WorkoutTimeLabel.text = "TIME: " +  GlobalData.seconds_in_minutes_string(currentTime - workoutStart)

func _setup_exercise_resulst():
	for exercise in workout.exercises:
		var exersiceResultDisplayNode = EXERSICE_RESULT_DISPLAY.instantiate()

		exersiceResultDisplayNode.exercise = exercise.talent
		
		if GlobalWorkout.exerciseReps.is_empty():
			print("Debug mode - workout_done")
			exersiceResultDisplayNode.repsDoneList = [5,5,5]
		else:
			exersiceResultDisplayNode.repsDoneList = GlobalWorkout.exerciseReps[workout.exercises.find(exercise)]
		
		%ExerciseResultContainer.add_child(exersiceResultDisplayNode)	

func _quit_page():
	get_tree().change_scene_to_file("res://main_menu_page/main_menu.tscn")
