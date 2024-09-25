extends Resource
class_name TalentResource

@export var icon : CompressedTexture2D
@export var unlocks: Array[TalentResource]
@export var goal := 10
@export var completed = false
@export var is_unlocked = false

#statistics
@export var firstTimeDoneDate: Dictionary
@export var goalAchievedDate: Dictionary
@export var bestResult : Array[int]
@export var maxReps := 0
@export var totalReps := 0
@export var totalSets := 0

enum MAIN_PARTS {PUSH, PULL, LEG, CORE}
var talentName = resource_path.get_file().trim_suffix('.tres')

func get_talent_name():
	return resource_path.get_file().trim_suffix('.tres').replace("_", " ")

func get_talent_file_name():
	return resource_path.get_file()
	
func get_origin_save_path():
	return resource_path

func get_category():
	if "Push" in resource_path: return "Push"
	elif "Pull" in resource_path: return "Pull"
	elif "Leg" in resource_path: return "Leg"
	elif "Core" in resource_path: return "Core"

func get_talent_level():
	return resource_path.split("/")[-2][-1]

func load_save_data():
	return SaveAndLoad.load_exercise_saveFile(self)

func get_save_file():
	var newResource = ResourceLoader.load(get_origin_save_path())
	
	newResource.completed = completed
	newResource.is_unlocked = is_unlocked
	newResource.firstTimeDoneDate = firstTimeDoneDate
	newResource.goalAchievedDate = goalAchievedDate
	newResource.bestResult = bestResult
	newResource.maxReps = maxReps
	newResource.totalReps = totalReps
	newResource.totalSets = totalSets
	
	return newResource
	
func get_main_part():
	if "Push" in get_origin_save_path(): return MAIN_PARTS.PUSH
	elif "Pull" in get_origin_save_path(): return MAIN_PARTS.PULL
	elif "Leg" in get_origin_save_path(): return MAIN_PARTS.LEG
	elif "Core" in get_origin_save_path(): return MAIN_PARTS.CORE

func save() -> void:
	SaveAndLoad.save_resource(SaveAndLoad.saveExerciseDataPath, get_save_file())
