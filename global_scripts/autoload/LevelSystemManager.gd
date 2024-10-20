extends Node

const STRENGTH_FACTOR = 100
const MAX_POINT_REP = 10

func get_overall_strength() -> int:
	return (get_push_data().strength + get_pull_data().strength + 
		get_leg_data().strength + get_core_Data().strength)

func get_push_data() -> Dictionary:
	return {
		"level": _get_level(GlobalData.exercice_type.PUSH),
		"strength": _get_strength(GlobalData.exercice_type.PUSH)
	}
	
func get_pull_data() -> Dictionary:
	return {
		"level": _get_level(GlobalData.exercice_type.PULL),
		"strength": _get_strength(GlobalData.exercice_type.PULL)
	}
	
func get_leg_data() -> Dictionary:
	return {
		"level": _get_level(GlobalData.exercice_type.LEG),
		"strength": _get_strength(GlobalData.exercice_type.LEG)
	}
	
func get_core_Data() -> Dictionary:
	return {
		"level": _get_level(GlobalData.exercice_type.CORE),
		"strength": _get_strength(GlobalData.exercice_type.CORE)
	}

func _get_level(part: GlobalData.exercice_type) -> int:
	var talentPath := _get_excersies_main_path(part)
	var level := 1

	for i in 14:
		var serachFolder: String = talentPath + "level" + str(i+1) + "/"
		var unlocked := false
		
		for fileName in DirAccess.get_files_at(serachFolder):
			if not ResourceLoader.exists(GlobalData.SAVE_EXERSICE_PATH  + fileName): continue
			
			var resource: TalentResource = ResourceLoader.load(GlobalData.SAVE_EXERSICE_PATH + fileName)
			if resource.is_unlocked: unlocked = resource.is_unlocked

		if unlocked: 
			level += 1
			unlocked = false
		else: break
	
	return level

func _get_excersies_main_path(part: GlobalData.exercice_type) -> String:
	match part:
		GlobalData.exercice_type.PUSH: return "res://resrouces/talent_resources/Push/"
		GlobalData.exercice_type.PULL: return "res://resrouces/talent_resources/Pull/"
		GlobalData.exercice_type.LEG: return "res://resrouces/talent_resources/Leg/"
		GlobalData.exercice_type.CORE: return "res://resrouces/talent_resources/Core/"
		
	return ""

func _get_level_in_strength(level: int) -> int:
	level -= 1
	return (level * (level + 1)) / 2 * STRENGTH_FACTOR

func _get_rep_strength(levelPath: String, level: int) -> int:
	var maxReps := 0
	
	for fileName in DirAccess.get_files_at(levelPath + str(level)):
		var loadPath: String = GlobalData.SAVE_EXERSICE_PATH + fileName
		
		if not ResourceLoader.exists(loadPath): continue
		
		var exerciseResource: TalentResource = ResourceLoader.load(loadPath)
		
		if exerciseResource: 
			maxReps = exerciseResource.maxReps
		
		if maxReps > MAX_POINT_REP: maxReps = MAX_POINT_REP
		
	
	if maxReps < 3: return 0
	
	return (maxReps - 3) * level * 100 / (MAX_POINT_REP - 3)

func _get_strength(part: GlobalData.exercice_type) -> int:
	var talentPath := _get_excersies_main_path(part)
	var level := _get_level(part)
	var levelStrength := _get_level_in_strength(level)
	var repStrength := _get_rep_strength(talentPath + "/level", level)

	return levelStrength + repStrength	

func unlock_talents(talent: TalentResource) -> void:
	var unlockTalents := talent.unlocks

	for unlockTalent: TalentResource in unlockTalents:
		var loadedResource := unlockTalent.load_save_data()
		loadedResource.is_unlocked = true
		loadedResource.save()
		
	unlock_previous_talents(talent)

func unlock_previous_talents(talent: TalentResource) -> void:
	var talentLevel := int(talent.get_talent_level())
	var mainPart := talent.get_exercice_type()
	var talentPath := _get_excersies_main_path(mainPart)
	var searchTalentNames := [talent.get_talent_name()]
	
	for i in range(talentLevel-1, 0, -1):
		var serachFolder: String = talentPath + "level" + str(i) + "/"
		
		for fileName in DirAccess.get_files_at(serachFolder):
			if not ResourceLoader.exists(serachFolder + fileName): continue
			var resource : TalentResource = ResourceLoader.load(serachFolder + fileName)
			
			for lookTalent in resource.unlocks:
				var lookTalentName := lookTalent.get_talent_name()
				
				if searchTalentNames.has(lookTalentName):
					searchTalentNames.erase(lookTalentName)
					resource.is_unlocked = true
					resource.completed = true
					searchTalentNames.append(resource.get_talent_name())
					unlock_talents(resource)
					
					resource.save()
