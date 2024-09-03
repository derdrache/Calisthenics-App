extends PanelContainer

@export var workoutData : WorkoutResource = null

@onready var display_box = %DisplayBox
@onready var setup_workout_button: Button = %SetupWorkoutButton

const TALENT_SELECTION_BUTTON = preload("res://widgets/talent_selection_button.tscn")

var displayDate : Dictionary = Time.get_datetime_dict_from_system()

func _ready():	
	setup_workout_button.pressed.connect(_setup_workout)
	SignalHub.calendar_date_selected.connect(_change_workout_data)
	
	setup_workout_button.hide()

	_change_workout_data(Time.get_datetime_dict_from_system())
	
func _set_display():
	%Title.text = str(displayDate.day) + "." + str(displayDate.month) + ". Workout"
	
	if not workoutData or not _is_in_future(displayDate): %deleteWorkoutContainer.hide()
	else: %deleteWorkoutContainer.show()

	if not workoutData: 
		setup_workout_button.show()
		
		if not _is_in_future(displayDate): 
			setup_workout_button.text = "Not trained"
		else: setup_workout_button.text = "No workout - set up yet"
	else:
		setup_workout_button.hide()	
		
		for exercise in workoutData.exercises:
			var workoutIconNode = TALENT_SELECTION_BUTTON.instantiate()
			workoutIconNode.withTalentSelection = false
			workoutIconNode.small = true
			
			display_box.add_child(workoutIconNode)
			
			workoutIconNode.set_talent(exercise.talent)
			
func _setup_workout():
	if not GlobalWorkout.currentWorkout:
		get_tree().change_scene_to_file("res://main_menu_page/workout_page/setting/setting_workout_page.tscn")
	else: 
		if not _is_in_future(displayDate): return
		
		workoutData = GlobalWorkout.currentWorkout

		GlobalWorkout.add_workout(SaveAndLoad.plannedWorkoutFile, displayDate)
		_refresh_display()
		
func _is_in_future(date):
	var currentDateUnix = Time.get_unix_time_from_system()
	var selectedDateUnix = Time.get_unix_time_from_datetime_dict(date)

	return selectedDateUnix >= currentDateUnix

func _change_workout_data(date):
	displayDate = date
	var workout = GlobalWorkout.get_workout_history_data(date)
	if not workout: workout = GlobalWorkout.get_workout_plan(date)

	if workout: 
		workoutData = str_to_var(workout.workout)
		displayDate = workout.date
	else: workoutData = null
	
	_refresh_display()

func _refresh_display():
	for node in display_box.get_children():
		node.queue_free()
		
	_set_display()
	
func _on_delete_workout_button_pressed() -> void:
	workoutData = null
	GlobalWorkout.delete_workout_plan(displayDate)
	
	_refresh_display()
	
	
