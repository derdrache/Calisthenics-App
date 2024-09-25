extends Node

var workoutResourceTemplate = preload("res://resrouces/workout_resources/Workout.tres").duplicate()

var currentWorkout : Resource = SaveAndLoad.load_workout_resources()
var currentExerciseIndex = 0
var startTime

var exerciseData= []

func _ready() -> void:
	_get_and_remove_unfinished_workout_plans()

func _get_and_remove_unfinished_workout_plans():
	var workoutPlans = _get_all_workout_plan()
	var deletePlanWorkouts = []
	
	for workoutPlan in workoutPlans:
		var currentDate = Time.get_datetime_dict_from_system()
		var planDate = workoutPlan.date
		var isWorkoutPast = planDate.day +1 <= currentDate.day or planDate.month +1 <= currentDate.month or planDate.year +1 <= currentDate.year
		
		if not isWorkoutPast: continue
		
		var workout = get_workout_history_data(workoutPlan.date)
		if workout.is_empty(): 
			deletePlanWorkouts.append(workoutPlan)

	for workoutPlan in deletePlanWorkouts:
		_remove_workout_plan(workoutPlan)	
	
func load_workout():
	currentWorkout = SaveAndLoad.load_workout_resources()
	
func get_current_exercise():
	if currentExerciseIndex > len(currentWorkout.exercises) -1:
		currentExerciseIndex = 0
	return currentWorkout.exercises[currentExerciseIndex]

func get_current_set():
	return exerciseData[currentExerciseIndex].setsDone + 1

func get_current_max_set():
	return exerciseData[currentExerciseIndex].maxSets
	
func get_break_time():
	return exerciseData[currentExerciseIndex - 1].breakTime

func start_workout():
	reset_workout_data()
	
	startTime = Time.get_time_dict_from_system()
	currentWorkout = SaveAndLoad.load_workout_resources()
	
	_setup_exercise_data()

func _setup_exercise_data():
	for exercise in currentWorkout.exercises:		
		exerciseData.append({
			"talent": exercise.talent,
			"setsDone": 0,
			"maxSets": exercise.sets,
			"breakTime": exercise.breakTime,
			"repsDone" : [],
		})

func next_exersice(repsDone):
	_add_reps(repsDone)
	_add_set()
	
	var modus = currentWorkout.modus
	var setsDone = exerciseData[currentExerciseIndex].setsDone
	var maxSets = int(exerciseData[currentExerciseIndex].maxSets)
	var exerciseDone = setsDone == maxSets
	
	
	if modus == "NORMAL":
		if exerciseDone: currentExerciseIndex += 1
	elif modus == "SUPERSET":
		var isEvenNumber = currentExerciseIndex % 2 == 0
		
		if isEvenNumber:
			currentExerciseIndex += 1
		else:
			if exerciseDone:
				currentExerciseIndex += 1
			else: currentExerciseIndex -= 1
		
func previous_exercise(pageName):
	var modus = currentWorkout.modus
	
	if exerciseData[currentExerciseIndex].setsDone == 0 and currentExerciseIndex == 0:
		return
	
	if "Workout" in pageName:
		get_tree().change_scene_to_file("res://main_menu_page/workout_page/doWorkout/break_page.tscn")
	elif "Break" in pageName:
		if modus == "NORMAL" or exerciseData.size() == 1: 
			currentExerciseIndex -= 1
		elif modus == "SUPERSET":
			var isEvenNumber = currentExerciseIndex % 2 == 0
			var setsDone = exerciseData[currentExerciseIndex].setsDone

			if isEvenNumber and setsDone == 0:
				currentExerciseIndex -= 1
			elif isEvenNumber:
				currentExerciseIndex += 1
			else: currentExerciseIndex -= 1
		
		if currentExerciseIndex < 0: currentExerciseIndex = 0
		
		exerciseData[currentExerciseIndex].setsDone -= 1
		_remove_last_set()
		
		get_tree().change_scene_to_file("res://main_menu_page/workout_page/doWorkout/do_workout_page.tscn")

func is_workout_done():
	var setsDone = exerciseData[currentExerciseIndex].setsDone
	var maxSets = exerciseData[currentExerciseIndex].maxSets
	var isLastExercise = len(currentWorkout.exercises) - 1 == currentExerciseIndex
	
	return isLastExercise and setsDone == maxSets -1

func reset_workout_data():
	currentWorkout = null
	currentExerciseIndex = 0
	exerciseData = []
	startTime = null

func _add_reps(repsDone):
	exerciseData[currentExerciseIndex].repsDone.append(repsDone)

func _add_set():
	exerciseData[currentExerciseIndex].setsDone += 1

func _remove_last_set():
	exerciseData[currentExerciseIndex].repsDone.pop_back()


func save_workout(index, workoutData):
	var workoutResource = SaveAndLoad.load_workout_resources()
	
	if workoutResource == null: workoutResource = workoutResourceTemplate
	
	workoutResource.exercises = workoutData.exercises
	workoutResource.modus = workoutData.modus
	workoutResource.globalBreak = workoutData.globalBreak
	workoutResource.id = workoutResource.get_instance_id()
	
	currentWorkout = workoutResource
	
	SaveAndLoad.save_resource(SaveAndLoad.saveWorkoutPath, workoutResource, workoutData.name)

func workout_done():
	_save_exercise_data()
	add_workout(SaveAndLoad.workoutHistoryDataFile, Time.get_datetime_dict_from_system())
	
func _save_exercise_data():
	for exercise in exerciseData:
		var talentFileName = exercise.talent.get_talent_file_name()
		var repsDoneArray = exercise.repsDone
		
		var exerciseResource : TalentResource = SaveAndLoad.load_exercise_saveFile(exercise.talent)
		var oldRecord = exerciseResource.maxReps
		var totalRepsDone = 0

		if exerciseResource.totalReps == 0:
			exerciseResource.firstTimeDoneDate = Time.get_datetime_dict_from_system()
			LevelSystem.unlock_previous_talents(exercise.talent)
		
		for repIndex in len(repsDoneArray):
			var rep = repsDoneArray[repIndex]
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

		SaveAndLoad.save_resource(SaveAndLoad.saveExerciseDataPath, exerciseResource.get_save_file())

func add_workout(file, date):
	var workoutHistory = SaveAndLoad.load_data(file)	
	
	if not workoutHistory: workoutHistory = []
	
	var newWorkoutData = {}
	newWorkoutData.id = currentWorkout.id
	newWorkoutData.date = date
	newWorkoutData.workout = var_to_str(currentWorkout)
	
	workoutHistory.append(newWorkoutData)
	
	SaveAndLoad.save_data(file, workoutHistory)
	SignalHub.update_calendar.emit()
	
func get_workout_history_data(date : Dictionary) -> Dictionary:
	var workoutHistory = SaveAndLoad.load_data(SaveAndLoad.workoutHistoryDataFile)
	
	return _find_workout_data(workoutHistory, date)
	
func get_workout_plan(date):
	var workoutPlan = SaveAndLoad.load_data(SaveAndLoad.plannedWorkoutFile)
	return _find_workout_data(workoutPlan, date)
		
func _find_workout_data(fileData, date):
	if not fileData: return {}
	
	for workout in fileData:
		var sameDay = workout.date.day == date.day
		var sameMonth = workout.date.month == date.month
		var sameYear = workout.date.year == date.year
		
		if sameDay and sameMonth and sameYear:
			return workout
		
	return {}

func delete_workout_plan(date):
	var workoutPlan = SaveAndLoad.load_data(SaveAndLoad.plannedWorkoutFile)
	var index = -1
	
	for i in workoutPlan.size():
		var day = workoutPlan[i].date.day
		var month = workoutPlan[i].date.month
		var year = workoutPlan[i].date.year
		
		if day == date.day and month == date.month and year == date.year: 
			index = i
			break
		
	if index >= 0:
		workoutPlan.remove_at(index)
		SaveAndLoad.save_data(SaveAndLoad.plannedWorkoutFile, workoutPlan)
		SignalHub.update_calendar.emit()

func _get_all_workout_history_data():
	var workoutHistory = SaveAndLoad.load_data(SaveAndLoad.workoutHistoryDataFile)
	return workoutHistory
	
func _get_all_workout_plan():
	var workoutPlan = SaveAndLoad.load_data(SaveAndLoad.plannedWorkoutFile)
	return workoutPlan

func _remove_workout_plan(plan):
	var workoutPlan = SaveAndLoad.load_data(SaveAndLoad.plannedWorkoutFile)
	var deleteIndex = 0

	for i in workoutPlan.size():
		if workoutPlan[i].date == plan.date:
			deleteIndex = i

	workoutPlan.remove_at(deleteIndex)
	SaveAndLoad.save_data(SaveAndLoad.plannedWorkoutFile, workoutPlan)
