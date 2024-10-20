extends Control

@export var smallCalendar := false

@onready var columns_box: HBoxContainer = %ColumnsBox
@onready var top_navigation_bar: Control = %TopNavigationBar
@onready var previous_week: TextureRect = %previousWeek
@onready var next_week: TextureRect = %nextWeek
@onready var previous_month: TextureRect = %previousMonth
@onready var next_month: TextureRect = %nextMonth
@onready var month_year_label: Label = %MonthYearLabel

const DATE_LABEL = preload("res://widgets/calendar/DateLabel.tscn")
const MONTH_NAMES = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]

var selectedDate := Time.get_datetime_dict_from_system()
var monthsList := []

func _ready() -> void:	
	_set_calendar()
	
func _set_calendar() -> void:
	if smallCalendar:
		_set_small_calendar()
	else:
		set_big_calendar()

func _set_small_calendar() -> void:
	top_navigation_bar.hide()
	previous_month.hide()
	next_month.hide()
	
	month_year_label.text = MONTH_NAMES[selectedDate.month - 1] + " " + str(selectedDate.year)
	
	var selectedDateUnixTime := Time.get_unix_time_from_datetime_dict(selectedDate)
	var startDate := Time.get_datetime_dict_from_unix_time(
		selectedDateUnixTime - GlobalData.DAY_IN_UNIX_TIME * (_get_weekday_index(selectedDate)))
	
	var calculateDate := startDate
	for i in 7:
		_create_label(calculateDate, i % 7)
		calculateDate = _get_next_day(calculateDate)

func set_big_calendar() -> void:
	previous_week.hide()
	next_week.hide()
	
	month_year_label.text = MONTH_NAMES[selectedDate.month - 1] + " " + str(selectedDate.year)
	
	var firstOfMonthDate := _get_first_of_month_date(selectedDate)
	var firstOfMonthUnixTime := Time.get_unix_time_from_datetime_dict(firstOfMonthDate)

	var startWeekday: int = firstOfMonthDate.weekday -1
	if startWeekday == -1: startWeekday = 6
	
	var rows := 5
	var startDate := Time.get_datetime_dict_from_unix_time(
		firstOfMonthUnixTime - GlobalData.DAY_IN_UNIX_TIME * (_get_weekday_index(firstOfMonthDate)))
		
	var calculateDate := startDate
	
	for i in rows * 7:
		_create_label(calculateDate, i % 7)
		calculateDate = _get_next_day(calculateDate)
	
	if selectedDate.month != calculateDate.month: return
	
	for i in 7:
		_create_label(calculateDate, i % 7)
		calculateDate = _get_next_day(calculateDate)
	
func _create_label(date: Dictionary, index: int) -> void:
		var dateLabel: DateLabel = DATE_LABEL.instantiate()
		
		dateLabel.date = date
		
		var workoutCcollection := SaveAndLoad.load_workout_collection()
		dateLabel.workoutData = workoutCcollection.get_workout(date)

		columns_box.get_children()[index].add_child(dateLabel)	
	
func _get_first_of_month_date(date: Dictionary) -> Dictionary:
	date.day = 1

	var selectedUnixTime := Time.get_unix_time_from_datetime_dict(date)
	
	return Time.get_datetime_dict_from_unix_time(selectedUnixTime)

func _get_next_day(date: Dictionary) -> Dictionary:
		var nextDayUnixTime: int = Time.get_unix_time_from_datetime_dict(date) + GlobalData.DAY_IN_UNIX_TIME
		
		return Time.get_datetime_dict_from_unix_time(nextDayUnixTime)	

func _on_previous_month_button_pressed() -> void:
	selectedDate.month -= 1
	
	_refresh_calendar()

func _on_next_month_button_pressed() -> void:
	selectedDate.month += 1
	
	_refresh_calendar()

func _refresh_calendar() -> void:
	if selectedDate.month > 12:
		selectedDate.month = 1
		selectedDate.year += 1
	elif selectedDate.month < 1:
		selectedDate.month = 12
		selectedDate.year -= 1
	
	for column in columns_box.get_children():
		for node in column.get_children():
			if node is Label: continue
			
			node.queue_free()
	
	_set_calendar()

func _get_weekday_index(date: Dictionary) -> int:
	var index: int = date.weekday -1
	if index == -1: index = 6	
	
	return index

func _on_previous_week_button_pressed() -> void:
	var newUnixTime := Time.get_unix_time_from_datetime_dict(selectedDate) - 7 * GlobalData.DAY_IN_UNIX_TIME
	selectedDate = Time.get_datetime_dict_from_unix_time(newUnixTime)
	
	_refresh_calendar()

func _on_next_week_button_pressed() -> void:
	var newUnixTime := Time.get_unix_time_from_datetime_dict(selectedDate) + 7 * GlobalData.DAY_IN_UNIX_TIME
	selectedDate = Time.get_datetime_dict_from_unix_time(newUnixTime)
	
	_refresh_calendar()
