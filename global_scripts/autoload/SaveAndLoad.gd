extends Node


func save_resource(path: String, resource: Resource, fileName := "") -> void:
	if fileName: fileName = fileName.replace(" ", "_") + ".tres"
	else: fileName = resource.resource_path.get_file()

	ResourceSaver.save(resource, path + fileName)

func load_workout_resources() -> WorkoutResource:	
	for fileName in DirAccess.get_files_at(GlobalData.SAVE_WORKOUT_PATH):
		if fileName.get_extension()== "tres":
			var resource := ResourceLoader.load(GlobalData.SAVE_WORKOUT_PATH + fileName)
			return resource
	return

func load_workout_collection() -> WorkoutCollectionResource:
	var resource: WorkoutCollectionResource
	
	if ResourceLoader.exists(GlobalData.WOKROUT_COLLECTION):
		resource = ResourceLoader.load(GlobalData.WOKROUT_COLLECTION)
	else: 
		resource = ResourceLoader.load(GlobalData.WORKOUT_COLLECTION_TEMPLATE).duplicate()
	
	return resource
	
#func load_exercise_saveFile(excersice: TalentResource):
	#for fileName in DirAccess.get_files_at(saveExerciseDataPath):
		#if fileName == excersice.get_talent_file_name():
			#var resource = ResourceLoader.load(saveExerciseDataPath + fileName)
			#return resource
#
	#var resource = load(excersice.get_origin_save_path())
	#return resource
	


#func save_data(save_path: String, data: Dictionary) -> void:
	#var file := FileAccess.open(save_path, FileAccess.WRITE)
	#var jsonString := JSON.stringify(data)
	#file.store_line(jsonString)
	#
#func load_data(save_path: String) -> Dictionary:
	#var file = FileAccess.open(save_path, FileAccess.READ)
	#
	#if FileAccess.file_exists(save_path):
		#var data = JSON.parse_string(file.get_line())
		#return data
	#
	#return {}
