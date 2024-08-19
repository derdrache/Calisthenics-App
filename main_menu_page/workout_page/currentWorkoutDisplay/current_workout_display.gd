extends PanelContainer

@onready var display_box = %DisplayBox
@onready var setup_workout_button: Button = %SetupWorkoutButton

const TALENT_SELECTION_BUTTON = preload("res://widgets/talent_selection_button.tscn")

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
			var workoutIconNode = TALENT_SELECTION_BUTTON.instantiate()
			workoutIconNode.withTalentSelection = false
			workoutIconNode.small = true
			
			display_box.add_child(workoutIconNode)
			
			workoutIconNode.set_talent(exercise.talent)
			
func _setup_workout():
	get_tree().change_scene_to_file("res://main_menu_page/workout_page/setting/setting_workout_page.tscn")
