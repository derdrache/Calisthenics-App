extends Resource
class_name WorkoutResource

@export var workoutName : String
@export var id: int
@export var planDate: Dictionary
@export var doneDate: Dictionary
@export var exercises : Array
@export var modus : String
@export var globalBreak: int
@export var selected = false


func get_date():
	if doneDate: return doneDate
	else: return planDate
