extends PanelContainer

@onready var display_box = %DisplayBox


const EXERCISE_ICON = preload("res://widgets/excersice_icon/exercise_icon.tscn")

var workoutData = SaveAndLoad.load_workout_resources()

func _ready():	
	_set_display()
	
func _set_display():
	for exercise in workoutData.exercises:
		var workoutIconNode = EXERCISE_ICON.instantiate()
		workoutIconNode.talent = exercise.talent
		
		display_box.add_child(workoutIconNode)
