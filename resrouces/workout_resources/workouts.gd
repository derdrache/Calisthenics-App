extends Resource
class_name WorkoutResource

@export var workoutName : String
@export var id: int
@export var planDate: Dictionary
@export var doneDate: Dictionary
@export var exercises : Array[Exercise]
@export var modus : GlobalData.workout_modus
@export var globalBreak: int
@export var selected := false


func get_date() -> Dictionary:
	if doneDate: return doneDate
	else: return planDate
