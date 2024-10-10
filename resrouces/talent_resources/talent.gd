extends Resource
class_name TalentResource

@export var icon : CompressedTexture2D
@export var unlocks: Array[TalentResource]
@export var goal := 10
@export var completed := false
@export var is_unlocked := false

#statistics
@export var firstTimeDoneDate: Dictionary
@export var goalAchievedDate: Dictionary
@export var bestResult : Array[int]
@export var maxReps := 0
@export var totalReps := 0
@export var totalSets := 0

var talentName:  String = resource_path.get_file().trim_suffix('.tres')

func get_talent_name() -> String:
	return resource_path.get_file().trim_suffix('.tres').replace("_", " ")

func get_talent_file_name() -> String:
	return resource_path.get_file()
	
func get_origin_save_path() -> String:
	return resource_path

#func get_category() -> GlobalData.exercies_type:
	#if "Push" in resource_path: return GlobalData.exercies_type.PUSH
	#elif "Pull" in resource_path: return GlobalData.exercies_type.PULL
	#elif "Leg" in resource_path: return GlobalData.exercies_type.LEG
	#elif "Core" in resource_path: return GlobalData.exercies_type.CORE
	#
	#return -1
	
func get_talent_level() -> String:
	return resource_path.split("/")[-2][-1]

func load_save_data() -> TalentResource:
	var saveExerciseDataPath := GlobalData.SAVE_EXERSICE_PATH
	var resource: TalentResource
	
	for fileName in DirAccess.get_files_at(saveExerciseDataPath):
		if fileName == get_talent_file_name():
			resource = ResourceLoader.load(saveExerciseDataPath + fileName)
			return resource

	resource = load(get_origin_save_path())
	
	return resource

func get_exercice_type() -> GlobalData.exercice_type:
	if "Push" in get_origin_save_path(): return GlobalData.exercice_type.PUSH
	elif "Pull" in get_origin_save_path(): return GlobalData.exercice_type.PULL
	elif "Leg" in get_origin_save_path(): return GlobalData.exercice_type.LEG
	elif "Core" in get_origin_save_path(): return GlobalData.exercice_type.CORE
	
	return GlobalData.exercice_type.PUSH

func save() -> void:
	SaveAndLoad.save_resource(GlobalData.SAVE_EXERSICE_PATH, _create_save_file())

func _create_save_file() -> TalentResource:
	var newResource: TalentResource = ResourceLoader.load(get_origin_save_path())
	
	newResource.completed = completed
	newResource.is_unlocked = is_unlocked
	newResource.firstTimeDoneDate = firstTimeDoneDate
	newResource.goalAchievedDate = goalAchievedDate
	newResource.bestResult = bestResult
	newResource.maxReps = maxReps
	newResource.totalReps = totalReps
	newResource.totalSets = totalSets
	
	return newResource
