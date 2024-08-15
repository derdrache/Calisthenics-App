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

#
#func _load_car_resources():
	#for fileName in DirAccess.get_files_at(GlobalData.saveFilesPath):
		#if fileName.get_extension()== "tres":
			#var savedCarRescource = load(GlobalData.saveFilesPath + fileName)
			#
			#for carResName in DirAccess.get_files_at(GlobalData.carResourcePath):
				#if carResName == fileName:
					#var carRescource = load(GlobalData.carResourcePath + carResName)
					#_overwrite_car_resource_data(savedCarRescource, carRescource)
