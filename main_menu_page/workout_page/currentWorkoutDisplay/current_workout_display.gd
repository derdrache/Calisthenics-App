extends PanelContainer

@onready var display_box = %DisplayBox
@onready var setup_workout_button: Button = %SetupWorkoutButton



const EXERCISE_ICON = preload("res://widgets/excersice_icon/exercise_icon.tscn")

var workoutData = SaveAndLoad.load_workout_resources()

func _ready():	
	setup_workout_button.hide()
	
	GlobalWorkout.load_workout()
	
	_set_display()
	
func _set_display():
	if not workoutData: 
		setup_workout_button.show()
		setup_workout_button.pressed.connect(_setup_workout)
	else:
		for exercise in workoutData.exercises:
			var workoutIconNode = EXERCISE_ICON.instantiate()
			workoutIconNode.talent = exercise.talent
			
			display_box.add_child(workoutIconNode)
			
func _setup_workout():
	get_tree().change_scene_to_file("res://main_menu_page/workout_page/setting/setting_workout_page.tscn")
