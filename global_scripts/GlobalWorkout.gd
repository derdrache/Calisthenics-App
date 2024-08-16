extends Node


var currentWorkout : Resource = SaveAndLoad.load_workout_resources()
var currentExerciseIndex = 0
var startTime

var exerciseData= []

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
		var index : int = currentWorkout.exercises.find(exercise)
		
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
	
	var modus = currentWorkout.workoutModus
	var setsDone = exerciseData[currentExerciseIndex].setsDone
	var maxSets = exerciseData[currentExerciseIndex].maxSets
	var exerciseDone = setsDone == maxSets
	
	if modus == "Normal":
		if exerciseDone: currentExerciseIndex += 1
	elif modus == "Superset":
		var isEvenNumber = currentExerciseIndex % 2 == 0
		
		if isEvenNumber:
			currentExerciseIndex += 1
		else:
			if exerciseDone:
				currentExerciseIndex += 1
			else: currentExerciseIndex -= 1
		
func _previous_exercise():
	#modus beachten!
	pass

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

func save_exercise_data():
	for i in len(exerciseData):
		var exercise = exerciseData[i]
		var talent = exercise.talent
		var repsGoal = talent.goal
		var repsDoneArray = exercise.repsDone
		
		var exerciseHistory = SaveAndLoad.load_exercise_history(talent.get_talent_name())
		var oldRecord = exerciseHistory.maxRep
		
		for repIndex in len(repsDoneArray):
			var rep = repsDoneArray[repIndex]
			
			if rep > exerciseHistory.maxRep: exerciseHistory.maxRep = rep
			exerciseHistory.totalReps += rep
			exerciseHistory.totalSets += 1
			
			
			if rep > exerciseHistory.bestResult[repIndex]:
				exerciseHistory.bestResult[repIndex] = rep
			
		SaveAndLoad.save_resource(SaveAndLoad.saveExerciseDataPath, exerciseHistory, talent.get_talent_name())
		
