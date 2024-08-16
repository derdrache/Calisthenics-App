extends Node

const saveWorkoutPath = "res://saveFiles/workout_templates/"
const saveExerciseDataPath = "res://saveFiles/exercises/"

func save_resource(path, resource, name = null):
	var fileName = resource.resource_path.get_file()
	
	if name: fileName = name.replace(" ", "_") + ".tres"
	
	ResourceSaver.save(resource, path + fileName)


func load_workout_resources():	
	for fileName in DirAccess.get_files_at(saveWorkoutPath):
		if fileName.get_extension()== "tres":
			var resource = load(saveWorkoutPath + fileName)
			return resource
			
func load_exercise_history(name):
	var done = false
	
	for fileName in DirAccess.get_files_at(saveExerciseDataPath):
		var fileNormalName = fileName.split(".")[0]
		if fileNormalName == name:
			done = true
			var resource = load(saveExerciseDataPath + fileName)
			return resource
	
	if not done: 
		var resource = load("res://resrouces/exercise_hisotry.tres").duplicate()
		resource.firstTimeDoneDate = Time.get_datetime_dict_from_system()	
		return resource
