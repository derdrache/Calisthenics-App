extends MarginContainer

@onready var workout_indicator: PanelContainer = %WorkoutIndicator


@export var date: Dictionary
@export var workoutData: Dictionary

const WORKOUT_STILL_DO_COLOR = Color(0.5,0.5,0.5,1)
const WORKOUT_DONE_COLOR = Color(0,0.5,0,1)
const WORKOUT_NOT_MADE_COLOR = Color(1,1,1,1)

func _ready() -> void:
	%DateLabel.text = str(date.day)
	
	var currentDate = Time.get_datetime_dict_from_system()
	var isCurrentDate = date.day == currentDate.day and date.month == currentDate.month and date.year == currentDate.year
	
	if not isCurrentDate: %Panel.add_theme_stylebox_override("panel", StyleBoxEmpty.new())
	
	if workoutData.is_empty(): workout_indicator.add_theme_stylebox_override("panel", StyleBoxEmpty.new())
	else: _set_workout_indicator()

func _on_button_pressed():
	SignalHub.calendar_date_selected.emit(date)

func _set_workout_indicator():
	var styleBox = workout_indicator.get_theme_stylebox("panel").duplicate()
	var currentDate = Time.get_datetime_dict_from_system()
	var workoutDate = workoutData.date
	var compareDate = Time.get_unix_time_from_datetime_dict(workoutDate)  - Time.get_unix_time_from_datetime_dict(currentDate)
	
	if compareDate <= 0: styleBox.bg_color = WORKOUT_DONE_COLOR
	else: styleBox.bg_color = WORKOUT_STILL_DO_COLOR
		
	workout_indicator.add_theme_stylebox_override("panel", styleBox)
