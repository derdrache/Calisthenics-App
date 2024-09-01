extends Node

const basePath = "user://"
const saveWorkoutPath = "user://workout_templates/"
const saveExerciseDataPath = "user://exercises/"
const workoutHistoryDataFile = "user://workout_history.bin"
const plannedWorkoutFile = "user://workout_planned.bin"

func save_resource(path, resource, name = null):
	_check_paths()
		
	var fileName = resource.resource_path.get_file()
	
	if name: fileName = name.replace(" ", "_") + ".tres"
	
	ResourceSaver.save(resource, path + fileName)

func _check_paths():
	var dir = DirAccess.open(basePath)
	dir.make_dir("workout_templates")
	dir.make_dir("exercises")
	
func load_workout_resources():	
	for fileName in DirAccess.get_files_at(saveWorkoutPath):
		if fileName.get_extension()== "tres":
			var resource = ResourceLoader.load(saveWorkoutPath + fileName)
			return resource
			
func load_exercise_history(name):
	for fileName in DirAccess.get_files_at(saveExerciseDataPath):
		var fileNormalName = fileName.split(".")[0]
		if fileNormalName == name:
			var resource = load(saveExerciseDataPath + fileName)
			return resource
	
	var resource = load("res://resrouces/exercise_hisotry.tres").duplicate()
	resource.firstTimeDoneDate = Time.get_datetime_dict_from_system()	
	return resource

func save_data(save_path: String, data) -> void:
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	var jsonString = JSON.stringify(data)
	file.store_line(jsonString)
	
func load_data(save_path: String):
	var file = FileAccess.open(save_path, FileAccess.READ)
	
	if FileAccess.file_exists(save_path):
		var data = JSON.parse_string(file.get_line())
		
		return data
