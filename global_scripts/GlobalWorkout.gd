extends Node


var currentWorkout : Resource = SaveAndLoad.load_workout_resources()
var currentExerciseIndex = 0
var exercisesSetDict = {}
var maxSetList = []
var breakTimeList = []
var exerciseReps = {}
var startTime

func get_current_exercise():
	if currentExerciseIndex > len(currentWorkout.exercises) -1:
		currentExerciseIndex = 0
	return currentWorkout.exercises[currentExerciseIndex]

func get_current_set():
	if exercisesSetDict.is_empty():
		return 1
	else:
		return exercisesSetDict[currentExerciseIndex] + 1

func get_current_max_set():
	return maxSetList[currentExerciseIndex]
	
func get_break_time():
	return breakTimeList[currentExerciseIndex-1]

func start_workout():
	reset_workout_data()
	
	startTime = Time.get_time_dict_from_system()
	currentWorkout = SaveAndLoad.load_workout_resources()
	
	for exercise in currentWorkout.exercises:
		var exerciseIndex = currentWorkout.exercises.find(exercise)
		maxSetList.append(exercise.sets)
		breakTimeList.append(exercise.breakTime)
		exercisesSetDict[exerciseIndex] = 0

func next_exersice(repsDone):
	save_reps(repsDone)
	add_set()
	
	var modus = currentWorkout.workoutModus
	var setsDone = exercisesSetDict[currentExerciseIndex]
	var maxSets = currentWorkout.exercises[currentExerciseIndex].sets
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
	var setsDone = exercisesSetDict[currentExerciseIndex]
	var maxSets = currentWorkout.exercises[currentExerciseIndex].sets
	var isLastExercise = len(currentWorkout.exercises) - 1 == currentExerciseIndex
	
	return isLastExercise and setsDone == maxSets -1

func _sum(accum, number):
	return accum + number

func reset_workout_data():
	currentWorkout = null
	currentExerciseIndex = 0
	exercisesSetDict = {}
	maxSetList = []
	breakTimeList = []
	exerciseReps = {}
	startTime = null

func save_reps(repsDone):
	if not exerciseReps.has(currentExerciseIndex): 
		exerciseReps[currentExerciseIndex] = [repsDone]
	else:
		exerciseReps[currentExerciseIndex].append(repsDone)

func add_set():
	exercisesSetDict[currentExerciseIndex] += 1
