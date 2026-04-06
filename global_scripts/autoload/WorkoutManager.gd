extends Node

var workoutResourceTemplate: WorkoutResource = preload("res://resrouces/workout_resources/Workout.tres").duplicate()
var currentWorkout : WorkoutResource
var currentExerciseIndex := 0
var startTime: Dictionary
	
func get_current_exercise() -> Exercise:
	if currentExerciseIndex > len(currentWorkout.exercises) -1:
		currentExerciseIndex = 0
	
	return currentWorkout.exercises[currentExerciseIndex]

func get_current_set() -> int:
	return currentWorkout.exercises[currentExerciseIndex].setsDone + 1

func get_current_max_set() -> int:
	return currentWorkout.exercises[currentExerciseIndex].maxSets
	
func get_break_time() -> int:
	return currentWorkout.exercises[currentExerciseIndex - 1].breakTime

func start_workout() -> void:
	reset_workout_data()
	
	startTime = Time.get_time_dict_from_system()
	currentWorkout = GlobalData.workouts[0]
	currentWorkout.reset()

func set_next_exersice(repsDone: int) -> void:
	_add_reps(repsDone)
	_add_set()
	
	var modus: GlobalData.workout_modus = currentWorkout.modus
	var setsDone: int = currentWorkout.exercises[currentExerciseIndex].setsDone
	var maxSets := int(currentWorkout.exercises[currentExerciseIndex].maxSets)
	var isExerciseDone := setsDone == maxSets
	
	
	if modus == GlobalData.workout_modus.NORMAL:
		if isExerciseDone: currentExerciseIndex += 1
	elif modus == GlobalData.workout_modus.SUPERSET:
		var isEvenNumber := currentExerciseIndex % 2 == 0
		
		if isEvenNumber:
			currentExerciseIndex += 1
		else:
			if isExerciseDone:
				currentExerciseIndex += 1
			else: currentExerciseIndex -= 1
		
func set_previous_exercise(pageName: String) -> void:
	var modus := currentWorkout.modus
	
	if currentWorkout.exercises[currentExerciseIndex].setsDone == 0 and currentExerciseIndex == 0:
		return
	
	if "Workout" in pageName:
		get_tree().change_scene_to_file("res://main_menu_page/workout_page/doWorkout/break_page.tscn")
	elif "Break" in pageName:
		if modus == GlobalData.workout_modus.NORMAL or currentWorkout.exercises.size() == 1: 
			currentExerciseIndex -= 1
		elif modus == GlobalData.workout_modus.SUPERSET:
			var isEvenNumber := currentExerciseIndex % 2 == 0
			var setsDone: int = currentWorkout.exercises[currentExerciseIndex].setsDone

			if isEvenNumber and setsDone == 0:
				currentExerciseIndex -= 1
			elif isEvenNumber:
				currentExerciseIndex += 1
			else: currentExerciseIndex -= 1
		
		if currentExerciseIndex < 0: currentExerciseIndex = 0
		
		currentWorkout.exercises[currentExerciseIndex].setsDone -= 1
		_remove_last_set()
		
		get_tree().change_scene_to_file("res://main_menu_page/workout_page/doWorkout/do_workout_page.tscn")

func is_workout_done() -> bool:
	var setsDone: int = currentWorkout.exercises[currentExerciseIndex].setsDone
	var maxSets: int= currentWorkout.exercises[currentExerciseIndex].maxSets
	var isLastExercise := len(currentWorkout.exercises) - 1 == currentExerciseIndex
	
	return isLastExercise and setsDone == maxSets -1

func reset_workout_data() -> void:
	currentWorkout = null
	currentExerciseIndex = 0
	startTime = {}

func _add_reps(repsDone: int) -> void:
	currentWorkout.exercises[currentExerciseIndex].repsDone.append(repsDone)

func _add_set() -> void:
	currentWorkout.exercises[currentExerciseIndex].setsDone += 1

func _remove_last_set() -> void:
	currentWorkout.exercises[currentExerciseIndex].repsDone.pop_back()

func workout_done() -> void:
	_save_exercise_data()
	
	var workoutData :WorkoutResource = currentWorkout.duplicate()
	workoutData.doneDate = Time.get_datetime_dict_from_system()
	
	var workoutCollection := SaveAndLoad.load_workout_collection()
	workoutCollection.add_workout(workoutData, "History")
	
	SaveAndLoad.save_global_exercise_data()

func _save_exercise_data() -> void:
	for exercise: Exercise in currentWorkout.exercises:
		var exerciseHistoryResource : Exercise_History = SaveAndLoad.load_exercise_history(exercise.talent.get_uid())
		exerciseHistoryResource.add_data(exercise)

func delete_workout_plan(date: Dictionary) -> void:
	var workoutCollection := SaveAndLoad.load_workout_collection()

	workoutCollection.delete_plan_workout(date)	
	
	SignalHub.update_calendar.emit()
