extends PanelContainer

@onready var display_box = %DisplayBox


const WORKOUT_ICON = preload("res://main_menu_page/workout_page/currentWorkoutDisplay/workout_icon.tscn")

var workoutData = SaveAndLoad.load_workout_resources()

func _ready():	
	_set_display()
	
func _set_display():
	for exersice in workoutData.exersices:
		var workoutIconNode = WORKOUT_ICON.instantiate()
		workoutIconNode.exersiceName = exersice.talent.get_talent_name()
		
		display_box.add_child(workoutIconNode)
