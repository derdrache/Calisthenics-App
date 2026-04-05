extends Resource
class_name Exercise_History

@export var uid: int
@export var firstTimeDoneDate : Dictionary
@export var goalAchievedDate: Dictionary
@export var maxRep := 0
@export var bestResult: Array[int] = [0,0,0]
@export var totalReps := 0
@export var totalSets := 0
@export var unlocked := false
@export var completed := false

func add_data(exerciseData: Exercise) -> void:
	var repsDoneArray: Array = exerciseData.repsDone
	var totalRepsDone := 0
	
	var goals: Array = [10, 10, 10]

	## todo check if one set at least 3 reps
	var hasMinimumReps: bool = repsDoneArray.any(func(val: int) -> bool: return val >= 3)
	if hasMinimumReps and firstTimeDoneDate.is_empty():
		firstTimeDoneDate = Time.get_datetime_dict_from_system()
		LevelSystemManager.unlock_talents(exerciseData.talent)
	
	for repIndex in len(repsDoneArray):
		var rep: int = repsDoneArray[repIndex]
		totalRepsDone += rep
		
		totalReps += rep
		totalSets += 1
		
		if rep > maxRep: maxRep = rep
		
		if rep >= 10 and not goals.is_empty():
			goals.pop_back()

		if bestResult.size() == repIndex:
			bestResult.append(rep)
		elif rep > bestResult[repIndex]:
			bestResult[repIndex] = rep
	
	if totalRepsDone >= 30 and not completed:
		for talent in exerciseData.talent.unlocks:
			LevelSystemManager.unlock_talents(talent)
	
	if not completed and goals.is_empty():
		LevelSystemManager.unlock_talents(exerciseData.talent)
		goalAchievedDate = {}
		completed = true
		GlobalData.exerciseCompleted.append(uid)
	
	_save()

func _save() -> void:
	SaveAndLoad.save_resource(GlobalData.SAVE_EXERSICE_PATH, self, str(uid))
