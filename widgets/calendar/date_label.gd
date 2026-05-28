extends MarginContainer
class_name DateLabel

@onready var workout_indicator: PanelContainer = %WorkoutIndicator
@onready var panel: Panel = %Panel
@onready var date_label: Label = %DateLabel

@export var date: Dictionary
@export var workoutData: WorkoutResource

const CURRENT_DATE_COLOR = Color("2161bd")
const DATE_SELECT_COLOR = Color(0.5,0.5,0.5,1)
const WORKOUT_STILL_DO_COLOR = Color(1.0, 1.0, 1.0, 1.0)
const WORKOUT_DONE_COLOR = Color(0,0.5,0,1)
const WORKOUT_NOT_MADE_COLOR = Color(1.0, 0.0, 0.0, 1.0)

func _ready() -> void:
	SignalHub.calendar_date_selected.connect(_on_date_selected)
	
	date_label.text = str(date.day)
	
	var currentDate := Time.get_datetime_dict_from_system()
	var isCurrentDate: bool = date.day == currentDate.day and date.month == currentDate.month and date.year == currentDate.year
	
	if not isCurrentDate: 
		_set_panel_color(Color.TRANSPARENT)
	
	if not workoutData: 
		workout_indicator.add_theme_stylebox_override("panel", StyleBoxEmpty.new())
	else: 
		_set_workout_indicator()

func _on_date_selected(selectedDate: Dictionary) -> void:
	if selectedDate == date:
		return

	var currentDate := Time.get_datetime_dict_from_system()
	var isCurrentDate: bool = date.day == currentDate.day and date.month == currentDate.month and date.year == currentDate.year
	if isCurrentDate:
		_set_panel_color(CURRENT_DATE_COLOR)
	else:
		_set_panel_color(Color.TRANSPARENT)


func _on_button_pressed() -> void:
	_set_panel_color(DATE_SELECT_COLOR)
	
	SignalHub.calendar_date_selected.emit(date)

func _set_panel_color(color: Color) -> void:
	var styleBox :StyleBoxFlat = panel.get_theme_stylebox("panel").duplicate()
	styleBox.bg_color = color
	panel.add_theme_stylebox_override("panel", styleBox)

func _set_workout_indicator() -> void:
	var styleBox :StyleBoxFlat = workout_indicator.get_theme_stylebox("panel").duplicate()
	var doneCheck: bool = not workoutData.is_done()
	
	if doneCheck: 
		styleBox.bg_color = WORKOUT_DONE_COLOR
	elif HelperFunctions.is_in_future(date):
		styleBox.bg_color = WORKOUT_STILL_DO_COLOR
	else: 
		styleBox.bg_color = WORKOUT_NOT_MADE_COLOR
		
	workout_indicator.add_theme_stylebox_override("panel", styleBox)
