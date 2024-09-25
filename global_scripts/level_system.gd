extends Node

enum MAIN_PARTS {PUSH, PULL, LEG, CORE}

const STRENGTH_FACTOR = 100
const MAX_POINT_REP = 10

func _ready() -> void:
	pass#unlock_previous_talents(load("res://resrouces/talent_resources/Push/level4/Push_up.tres"))

func get_overall_strength():
	return (get_push_data().strength + get_pull_data().strength + 
		get_leg_data().strength + get_core_Data().strength)

func get_push_data() -> Dictionary:
	return {
		"level": _get_level(MAIN_PARTS.PUSH),
		"strength": _get_strength(MAIN_PARTS.PUSH)
	}
	
func get_pull_data() -> Dictionary:
	return {
		"level": _get_level(MAIN_PARTS.PULL),
		"strength": _get_strength(MAIN_PARTS.PULL)
	}
	
func get_leg_data():
	return {
		"level": _get_level(MAIN_PARTS.LEG),
		"strength": _get_strength(MAIN_PARTS.LEG)
	}
	
func get_core_Data():
	return {
		"level": _get_level(MAIN_PARTS.CORE),
		"strength": _get_strength(MAIN_PARTS.CORE)
	}

func _get_level(part: MAIN_PARTS):
	var talentPath = _get_main_path(part)
	var level = 1

	for i in 14:
		var serachFolder = talentPath + "level" + str(i+1) + "/"
		var unlocked = false
		
		for fileName in DirAccess.get_files_at(serachFolder):
			if not ResourceLoader.exists(serachFolder + fileName): continue
			
			var resource = ResourceLoader.load(serachFolder + fileName)
			if resource.is_unlocked: unlocked = resource.is_unlocked
			
		if unlocked: 
			level += 1
			unlocked = false
		else: break
	
	return level

func _get_main_path(part: MAIN_PARTS):
	match part:
		MAIN_PARTS.PUSH: return "res://resrouces/talent_resources/Push/"
		MAIN_PARTS.PULL: return "res://resrouces/talent_resources/Pull/"
		MAIN_PARTS.LEG: return "res://resrouces/talent_resources/Leg/"
		MAIN_PARTS.CORE: return "res://resrouces/talent_resources/Core/"

func _get_level_in_strength(level):
	level -= 1
	return (level * (level + 1)) / 2 * STRENGTH_FACTOR

func _get_rep_strength(levelPath, level):
	var maxReps = 0
	
	for fileName in DirAccess.get_files_at(levelPath + str(level)):
		var loadPath = SaveAndLoad.saveExerciseDataPath + fileName
		
		if not ResourceLoader.exists(loadPath): continue
		
		var exerciseResource = ResourceLoader.load(loadPath)
		
		if exerciseResource: 
			maxReps = exerciseResource.maxReps
		
		if maxReps > MAX_POINT_REP: maxReps = MAX_POINT_REP
		
	
	if maxReps < 3: return 0
	
	return (maxReps - 3) * level * 100 / (MAX_POINT_REP - 3)

func _get_strength(part: MAIN_PARTS):
	var talentPath = _get_main_path(part)
	var level = _get_level(part)
	var levelStrength = _get_level_in_strength(level)
	var repStrength = _get_rep_strength(talentPath + "/level", level)

	return levelStrength + repStrength	

func unlock_talents(talent: TalentResource):
	var unlockTalents = talent.unlocks

	for unlockTalent in unlockTalents:
		var loadedResource = unlockTalent.load_save_data()
		loadedResource.is_unlocked = true
		loadedResource.save()
		
	unlock_previous_talents(talent)

func unlock_previous_talents(talent: TalentResource):
	var talentLevel = int(talent.get_talent_level())
	var mainPart = talent.get_main_part()
	var talentPath = _get_main_path(mainPart)
	var searchTalentNames = [talent.get_talent_name()]
	
	for i in range(talentLevel-1, 0, -1):
		var serachFolder = talentPath + "level" + str(i) + "/"
		
		for fileName in DirAccess.get_files_at(serachFolder):
			if not ResourceLoader.exists(serachFolder + fileName): continue
			var resource : TalentResource = ResourceLoader.load(serachFolder + fileName)
			
			for lookTalent in resource.unlocks:
				var lookTalentName = lookTalent.get_talent_name()
				
				if searchTalentNames.has(lookTalentName):
					searchTalentNames.erase(lookTalentName)
					resource.is_unlocked = true
					resource.completed = true
					searchTalentNames.append(resource.get_talent_name())
					unlock_talents(resource)
					
					resource.save()
