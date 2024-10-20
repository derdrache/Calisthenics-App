extends PanelContainer

@export var workoutData : WorkoutResource = null

@onready var title: Label = %Title
@onready var display_box: HBoxContainer = %DisplayBox
@onready var setup_workout_button : Button = %SetupWorkoutButton
@onready var delete_workout_container: MarginContainer = %deleteWorkoutContainer



const TALENT_SELECTION_BUTTON = preload("res://widgets/talent_selection_button.tscn")

var displayDate : Dictionary = Time.get_datetime_dict_from_system()

func _ready() -> void:
	setup_workout_button.pressed.connect(_setup_workout)
	SignalHub.calendar_date_selected.connect(_change_workout_data)
	
	setup_workout_button.hide()

	_change_workout_data(Time.get_datetime_dict_from_system())
	
func _set_display() -> void:
	title.text = str(displayDate.day) + "." + str(displayDate.month) + ". Workout"
	
	if not workoutData or not _is_in_future(displayDate): delete_workout_container.hide()
	else: delete_workout_container.show()

	if not workoutData: 
		setup_workout_button.show()
		
		if not _is_in_future(displayDate): 
			setup_workout_button.text = "Not trained"
		else: 
			setup_workout_button.text = "No workout - set up yet"
	else:
		setup_workout_button.hide()	
		
		for exercise in workoutData.exercises:
			var workoutIconNode: TalentSelectionButton = TALENT_SELECTION_BUTTON.instantiate()
			workoutIconNode.withTalentSelection = false
			workoutIconNode.small = true
			
			display_box.add_child(workoutIconNode)
			
			workoutIconNode.set_talent(exercise.talent)
			
func _setup_workout() -> void:
	if not WorkoutManager.currentWorkout:
		get_tree().change_scene_to_file("res://main_menu_page/workout_page/setting/setting_workout_page.tscn")
	else: 
		if not _is_in_future(displayDate): return
		
		workoutData = WorkoutManager.currentWorkout.duplicate()
		workoutData.planDate = displayDate
		
		var workoutCollection := SaveAndLoad.load_workout_collection()
		workoutCollection.add_workout(workoutData, "Plan")
		
		_refresh_display()
		
func _is_in_future(date: Dictionary) -> bool:
	var currentDateUnix := Time.get_unix_time_from_system()
	var selectedDateUnix := Time.get_unix_time_from_datetime_dict(date)

	return selectedDateUnix >= currentDateUnix

func _change_workout_data(date: Dictionary) -> void:
	displayDate = date
	
	var workoutCollection := SaveAndLoad.load_workout_collection()
	workoutData = workoutCollection.get_workout(date)
	
	if workoutData: displayDate = workoutData.get_date()
	
	_refresh_display()

func _refresh_display() -> void:
	for node in display_box.get_children():
		node.queue_free()
		
	_set_display()
	
func _on_delete_workout_button_pressed() -> void:
	workoutData = null
	WorkoutManager.delete_workout_plan(displayDate)
	
	_refresh_display()
	
	
