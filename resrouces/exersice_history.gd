extends Resource
class_name Exercise_History

@export var uid: int
@export var firstTimeDoneDate : Dictionary
@export var goalAchievedDate: Dictionary
@export var maxRep := 0
@export var bestResult: Array[int] = [0,0,0]
@export var totalReps := 0
@export var totalSets := 0

func add_data(exerciseData) -> void:
	var repsDoneArray: Array = exerciseData.repsDone
	var totalRepsDone := 0

	if totalReps == 0:
		firstTimeDoneDate = Time.get_datetime_dict_from_system()
		LevelSystemManager.unlock_previous_talents(exerciseData.talent)
	
	for repIndex in len(repsDoneArray):
		var rep: int = repsDoneArray[repIndex]
		totalRepsDone += rep
		
		totalReps += rep
		totalSets += 1
		
		if rep > maxRep: maxRep = rep

		if bestResult.size() == repIndex:
			bestResult.append(rep)
		elif rep > bestResult[repIndex]:
			bestResult[repIndex] = rep
	
	if totalRepsDone >= 30 and not exerciseData.talent.completed:
		LevelSystemManager.unlock_talents(exerciseData.talent)

	_save()

func _save() -> void:
	SaveAndLoad.save_resource(GlobalData.SAVE_EXERSICE_PATH, self, str(uid))
