extends MarginContainer
class_name DateLabel

@onready var workout_indicator: PanelContainer = %WorkoutIndicator
@onready var panel: Panel = %Panel
@onready var date_label: Label = %DateLabel


@export var date: Dictionary
@export var workoutData: WorkoutResource

const WORKOUT_STILL_DO_COLOR = Color(0.5,0.5,0.5,1)
const WORKOUT_DONE_COLOR = Color(0,0.5,0,1)
const WORKOUT_NOT_MADE_COLOR = Color(1,1,1,1)

func _ready() -> void:
	date_label.text = str(date.day)
	
	var currentDate := Time.get_datetime_dict_from_system()
	var isCurrentDate: bool = date.day == currentDate.day and date.month == currentDate.month and date.year == currentDate.year
	
	if not isCurrentDate: panel.add_theme_stylebox_override("panel", StyleBoxEmpty.new())
	
	if not workoutData: workout_indicator.add_theme_stylebox_override("panel", StyleBoxEmpty.new())
	else: _set_workout_indicator()

func _on_button_pressed() -> void:
	SignalHub.calendar_date_selected.emit(date)

func _set_workout_indicator() -> void:
	var styleBox :StyleBoxFlat = workout_indicator.get_theme_stylebox("panel").duplicate()
	var currentDate := Time.get_datetime_dict_from_system()
	var workoutDate := workoutData.get_date()
	var doneCheck: bool = (workoutDate.day +1 <= currentDate.day 
		or workoutDate.month +1 <= currentDate.month or workoutDate.year +1 <= currentDate.year)
	
	if doneCheck: styleBox.bg_color = WORKOUT_DONE_COLOR
	else: styleBox.bg_color = WORKOUT_STILL_DO_COLOR
		
	workout_indicator.add_theme_stylebox_override("panel", styleBox)
