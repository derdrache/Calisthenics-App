extends Resource
class_name TalentResource

@export var icon : CompressedTexture2D
@export var unlocks: Array[TalentResource]
@export var is_unlocked = false
@export var goal = 10

var talentName = resource_path.get_file().trim_suffix('.tres')

func get_talent_name():
	return resource_path.get_file().trim_suffix('.tres').replace("_", " ")

func get_category():
	if "Push" in resource_path: return "Push"
	elif "Pull" in resource_path: return "Pull"
	elif "Leg" in resource_path: return "Leg"
	elif "Core" in resource_path: return "Core"

func get_talent_level():
	return resource_path.split("/")[-2]
