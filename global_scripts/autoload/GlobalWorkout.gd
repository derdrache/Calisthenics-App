extends Node

var workoutResourceTemplate: WorkoutResource = preload("res://resrouces/workout_resources/Workout.tres").duplicate()

var currentWorkout : WorkoutResource = SaveAndLoad.load_workout_resources()
var currentExerciseIndex := 0
var startTime: Dictionary

var exerciseData : Array[Exercise] = []

func _ready() -> void:
	var workoutCollection := get_workout_collection()
	workoutCollection.delete_unfinished_workout_plans()
	
func get_current_exercise() -> Exercise:
	if currentExerciseIndex > len(currentWorkout.exercises) -1:
		currentExerciseIndex = 0
	
	return currentWorkout.exercises[currentExerciseIndex]

func get_current_set() -> int:
	return exerciseData[currentExerciseIndex].setsDone + 1

func get_current_max_set() -> int:
	return exerciseData[currentExerciseIndex].maxSets
	
func get_break_time() -> int:
	return exerciseData[currentExerciseIndex - 1].breakTime

func start_workout() -> void:
	reset_workout_data()
	
	startTime = Time.get_time_dict_from_system()
	currentWorkout = SaveAndLoad.load_workout_resources()
	
	_setup_exercise_data()

func _setup_exercise_data() -> void:
	exerciseData = currentWorkout.exercises

func set_next_exersice(repsDone: int) -> void:
	_add_reps(repsDone)
	_add_set()
	
	var modus: GlobalData.workout_modus = currentWorkout.modus
	var setsDone: int = exerciseData[currentExerciseIndex].setsDone
	var maxSets := int(exerciseData[currentExerciseIndex].maxSets)
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
	
	if exerciseData[currentExerciseIndex].setsDone == 0 and currentExerciseIndex == 0:
		return
	
	if "Workout" in pageName:
		get_tree().change_scene_to_file("res://main_menu_page/workout_page/doWorkout/break_page.tscn")
	elif "Break" in pageName:
		if modus == GlobalData.workout_modus.NORMAL or exerciseData.size() == 1: 
			currentExerciseIndex -= 1
		elif modus == GlobalData.workout_modus.SUPERSET:
			var isEvenNumber := currentExerciseIndex % 2 == 0
			var setsDone: int = exerciseData[currentExerciseIndex].setsDone

			if isEvenNumber and setsDone == 0:
				currentExerciseIndex -= 1
			elif isEvenNumber:
				currentExerciseIndex += 1
			else: currentExerciseIndex -= 1
		
		if currentExerciseIndex < 0: currentExerciseIndex = 0
		
		exerciseData[currentExerciseIndex].setsDone -= 1
		_remove_last_set()
		
		get_tree().change_scene_to_file("res://main_menu_page/workout_page/doWorkout/do_workout_page.tscn")

func is_workout_done() -> bool:
	var setsDone: int = exerciseData[currentExerciseIndex].setsDone
	var maxSets: int= exerciseData[currentExerciseIndex].maxSets
	var isLastExercise := len(currentWorkout.exercises) - 1 == currentExerciseIndex
	
	return isLastExercise and setsDone == maxSets -1

func reset_workout_data() -> void:
	currentWorkout = null
	currentExerciseIndex = 0
	exerciseData = []
	startTime = {}

func _add_reps(repsDone: int) -> void:
	exerciseData[currentExerciseIndex].repsDone.append(repsDone)

func _add_set() -> void:
	exerciseData[currentExerciseIndex].setsDone += 1

func _remove_last_set() -> void:
	exerciseData[currentExerciseIndex].repsDone.pop_back()

func save_workout(workoutData: WorkoutResource) -> void:
	var workoutResource := SaveAndLoad.load_workout_resources()
	
	if workoutResource == null: workoutResource = workoutResourceTemplate
	
	workoutResource.workoutName = workoutData.workoutName
	workoutResource.exercises = workoutData.exercises
	workoutResource.modus = workoutData.modus
	workoutResource.globalBreak = workoutData.globalBreak
	workoutResource.id = workoutResource.get_instance_id()
	
	currentWorkout = workoutResource
	
	SaveAndLoad.save_resource(GlobalData.SAVE_WORKOUT_PATH, workoutResource, workoutResource.workoutName)

func workout_done() -> void:
	_save_exercise_data()
	
	var workoutData :WorkoutResource = currentWorkout.duplicate()
	workoutData.doneDate = Time.get_datetime_dict_from_system()
	
	var workoutCollection := SaveAndLoad.load_workout_collection()
	workoutCollection.add_workout(workoutData, "History")

	SignalHub.update_calendar.emit()
	
func _save_exercise_data() -> void:
	for exercise: Exercise in exerciseData:
		var repsDoneArray: Array = exercise.repsDone
		var exerciseResource : TalentResource = exercise.talent.load_save_data()
		var totalRepsDone := 0

		if exerciseResource.totalReps == 0:
			exerciseResource.firstTimeDoneDate = Time.get_datetime_dict_from_system()
			LevelSystem.unlock_previous_talents(exercise.talent)
		
		for repIndex in len(repsDoneArray):
			var rep: int = repsDoneArray[repIndex]
			totalRepsDone += rep
			
			exerciseResource.totalReps += rep
			exerciseResource.totalSets += 1
			
			if rep > exerciseResource.maxReps: exerciseResource.maxReps = rep

			if exerciseResource.bestResult.size() == repIndex:
				exerciseResource.bestResult.append(rep)
			elif rep > exerciseResource.bestResult[repIndex]:
				exerciseResource.bestResult[repIndex] = rep
		
		if totalRepsDone >= 30 and not exerciseResource.completed:
			LevelSystem.unlock_talents(exerciseResource)
			exerciseResource.is_unlocked = true
			exerciseResource.completed = true
			exerciseResource.goalAchievedDate = Time.get_datetime_dict_from_system()

		exerciseResource.save()

func delete_workout_plan(date: Dictionary) -> void:
	var workoutCollection := get_workout_collection()

	workoutCollection.delete_plan_workout(date)	
	
	SignalHub.update_calendar.emit()

func get_workout_collection() -> WorkoutCollectionResource:
	return SaveAndLoad.load_workout_collection()
