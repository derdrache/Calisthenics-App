extends Node
class_name SaveAndLoad

static func save_resource(path: String, resource: Resource, fileName := "") -> void:
	if fileName: fileName = fileName.replace(" ", "_") + ".tres"
	else: fileName = resource.resource_path.get_file()
	
	ResourceSaver.save(resource, path + fileName)

static func load_workout_resources() -> Array[WorkoutResource]:
	var resources: Array[WorkoutResource]
	
	for fileName in DirAccess.get_files_at(GlobalData.SAVE_WORKOUT_PATH):
		if fileName.get_extension()== "tres":
			var resource := ResourceLoader.load(GlobalData.SAVE_WORKOUT_PATH + fileName)
			resources.append(resource)
			
	return resources
	
static func load_workout_collection() -> WorkoutCollectionResource:
	var resource: WorkoutCollectionResource
	
	if ResourceLoader.exists(GlobalData.WOKROUT_COLLECTION):
		resource = ResourceLoader.load(GlobalData.WOKROUT_COLLECTION)
	else: 
		resource = ResourceLoader.load(GlobalData.WORKOUT_COLLECTION_TEMPLATE).duplicate()
	
	return resource
	
static func load_exercise_history(uid: int) -> Exercise_History:
	var resource: Resource = ResourceLoader.load(GlobalData.SAVE_EXERSICE_PATH + str(uid) + ".tres")

	if resource:
		return resource
	else:
		var newHistory: Exercise_History = Exercise_History.new()
		newHistory.uid = uid
		return newHistory

static func save_global_exercise_data() -> void:
	var dict: Dictionary[String, Array] = {
		"unlocked": GlobalData.exerciseUnlocked,
		"completed": GlobalData.exerciseCompleted
	}
	
	var save_file := FileAccess.open(GlobalData.GLOBAL_EXERCISE_PATH, FileAccess.WRITE)
	var json_string := JSON.stringify(dict)
	
	save_file.store_line(json_string)

static func load_exercise_data() -> void:
	if not FileAccess.file_exists(GlobalData.GLOBAL_EXERCISE_PATH):
		return
		
	var save_file := FileAccess.open(GlobalData.GLOBAL_EXERCISE_PATH, FileAccess.READ)
	
	var json_string := save_file.get_line()
	var data: Dictionary = str_to_var(json_string)
	var unlocked: Array[int]
	unlocked.assign(data["unlocked"])
	
	var completed: Array[int]
	completed.assign(data["completed"])
	
	GlobalData.exerciseUnlocked = unlocked
	GlobalData.exerciseCompleted = completed
	
