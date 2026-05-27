extends PanelContainer

@export var workoutData : WorkoutResource = null

@onready var title: Label = %Title
@onready var display_box: HBoxContainer = %DisplayBox
#@onready var setup_workout_button : Button = %SetupWorkoutButton
@onready var delete_workout_container: MarginContainer = %deleteWorkoutContainer

const TALENT_SELECTION_BUTTON = preload("res://widgets/talent_selection_button.tscn")
const WORKOUT_SELECTION_BOX = preload("uid://b5v787yy3qjkq")

var displayDate : Dictionary = Time.get_datetime_dict_from_system()

func _ready() -> void:
	SignalHub.calendar_date_selected.connect(_change_workout_data)

	_change_workout_data(Time.get_datetime_dict_from_system())
	
func _set_display() -> void:	
	title.text = str(displayDate.day) + "." + str(displayDate.month) + ". "

	if workoutData:
		title.text += workoutData.workoutName
	else:
		title.text += "Select Workout:"
		
	if not workoutData or not HelperFunctions.is_in_future(displayDate): 
		delete_workout_container.hide()
	else: 
		delete_workout_container.show()
	
	if not workoutData: 
		for workout: WorkoutResource in SaveAndLoad.load_workout_resources():
			var workoutSelectionBoxNode := WORKOUT_SELECTION_BOX.instantiate()
			workoutSelectionBoxNode.workout = workout
			display_box.add_child(workoutSelectionBoxNode)
			workoutSelectionBoxNode.selected.connect(_on_workout_selection_box_selected)
	else:	
		for exercise in workoutData.exercises:
			var workoutIconNode: TalentSelectionButton = TALENT_SELECTION_BUTTON.instantiate()
			workoutIconNode.withTalentSelection = false
			workoutIconNode.small = true
			
			display_box.add_child(workoutIconNode)
			
			workoutIconNode.set_talent(exercise.talent)

func _on_workout_selection_box_selected(workout: WorkoutResource) -> void:
		if not HelperFunctions.is_in_future(displayDate): 
			return
		
		workoutData = workout.duplicate()
		workoutData.planDate = displayDate
		
		var workoutCollection := SaveAndLoad.load_workout_collection()
		workoutCollection.add_workout(workoutData, "Plan")
		
		_refresh_display()
		
		SignalHub.workout_changed.emit()

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

func _on_close_button_pressed() -> void:
	workoutData = null
	WorkoutManager.delete_workout_plan(displayDate)
	
	_refresh_display()
	
	SignalHub.workout_changed.emit()
