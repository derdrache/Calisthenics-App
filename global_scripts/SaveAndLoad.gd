extends Node

var saveFilesPath = "res://save_files/"
var saveWorkoutPath = "res://saveFiles/workout_templates/"

func save_resource(resource):
	var fileName = resource.resource_path.get_file()
	ResourceSaver.save(resource, saveWorkoutPath + fileName)
	
func load_workout_resources():	
	for fileName in DirAccess.get_files_at(saveWorkoutPath):
		if fileName.get_extension()== "tres":
			var resource = load(saveWorkoutPath + fileName)
			return resource

