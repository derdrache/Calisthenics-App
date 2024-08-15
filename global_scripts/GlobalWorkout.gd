extends Node


var currentWorkout : Resource
var currentExerciseIndex = 0
var currentSetList = []
var maxSetList = []
var breakTimeList = []

func get_current_exersice():
	if currentExerciseIndex > len(currentWorkout.exersices) -1:
		currentExerciseIndex = 0
	return currentWorkout.exersices[currentExerciseIndex]

func get_current_set():
	return currentSetList[currentExerciseIndex]

func get_current_max_set():
	return maxSetList[currentExerciseIndex]
	
func get_break_time():
	return breakTimeList[currentExerciseIndex-1]

func start_workout():
	reset_workout_data()
	
	currentWorkout = SaveAndLoad.load_workout_resources()
	
	for exersice in currentWorkout.exersices:
		currentSetList.append(1)
		maxSetList.append(exersice.sets)
		breakTimeList.append(exersice.breakTime)

func next_exersice():
	currentSetList[currentExerciseIndex] += 1
	currentExerciseIndex += 1
	
func _previous_exersice():
	currentExerciseIndex -= 1
	currentSetList[currentExerciseIndex] -= 1

func reset_workout_data():
	currentWorkout = null
	currentExerciseIndex = 0
	currentSetList = []
	maxSetList = []
	breakTimeList = []
