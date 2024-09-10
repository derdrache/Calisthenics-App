extends Control

@export var smallCalendar = false

@onready var columns_box: HBoxContainer = %ColumnsBox

const DATE_LABEL = preload("res://widgets/calendar/DateLabel.tscn")
const MONTH_NAMES = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]



var selectedDate = Time.get_datetime_dict_from_system()
var monthsList = []

func _ready() -> void:
	SignalHub.update_calendar.connect(_refresh_calendar)
	
	_set_calendar()
	
func _set_calendar():
	if smallCalendar:
		_set_small_calendar()
	else:
		set_big_calendar()

func _set_small_calendar():
	%TopNavigationBar.hide()
	%previousMonth.hide()
	%nextMonth.hide()
	
	var selectedDateUnixTime = Time.get_unix_time_from_datetime_dict(selectedDate)
	var startDate = Time.get_datetime_dict_from_unix_time(
		selectedDateUnixTime - GlobalData.DAY_IN_UNIX_TIME * (_get_weekday_index(selectedDate)))
	
	var calculateDate = startDate
	for i in 7:
		_create_label(calculateDate, i % 7)
		calculateDate = _get_next_day(calculateDate)

func set_big_calendar():
	%previousWeek.hide()
	%nextWeek.hide()
	
	%MonthYearLabel.text = MONTH_NAMES[selectedDate.month - 1] + " " + str(selectedDate.year)
	
	var firstOfMonthDate = _get_first_of_month(selectedDate)
	var firstOfMonthUnixTime = Time.get_unix_time_from_datetime_dict(firstOfMonthDate)

	var startWeekday = firstOfMonthDate.weekday -1
	if startWeekday == -1: startWeekday = 6
	
	var rows = 5
	var startDate = Time.get_datetime_dict_from_unix_time(
		firstOfMonthUnixTime - GlobalData.DAY_IN_UNIX_TIME * (_get_weekday_index(firstOfMonthDate)))
		
	var calculateDate = startDate
	
	for i in rows * 7:
		_create_label(calculateDate, i % 7)
		calculateDate = _get_next_day(calculateDate)
	
	if selectedDate.month != calculateDate.month: return
	
	for i in 7:
		_create_label(calculateDate, i % 7)
		calculateDate = _get_next_day(calculateDate)
	
func _create_label(date, index):
		var dateLabel = DATE_LABEL.instantiate()
		
		dateLabel.date = date
		dateLabel.workoutData = GlobalWorkout.get_workout_history_data(date)
		if not dateLabel.workoutData: dateLabel.workoutData = GlobalWorkout.get_workout_plan(date)

		%ColumnsBox.get_children()[index].add_child(dateLabel)	
	
func _get_first_of_month(date):
	date.day = 1

	var selectedUnixTime = Time.get_unix_time_from_datetime_dict(date)
	
	return Time.get_datetime_dict_from_unix_time(selectedUnixTime)

func _get_next_day(date):
		var nextDayUnixTime = Time.get_unix_time_from_datetime_dict(date) + GlobalData.DAY_IN_UNIX_TIME
		return Time.get_datetime_dict_from_unix_time(nextDayUnixTime)	

func _on_previous_month_button_pressed() -> void:
	selectedDate.month -= 1
	
	_refresh_calendar()

func _on_next_month_button_pressed() -> void:
	selectedDate.month += 1
	
	_refresh_calendar()

func _refresh_calendar():	
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

func _get_weekday_index(date):
	var index = date.weekday -1
	if index == -1: index = 6	
	
	return index

func _on_previous_week_button_pressed() -> void:
	var newUnixTime = Time.get_unix_time_from_datetime_dict(selectedDate) - 7 * GlobalData.DAY_IN_UNIX_TIME
	selectedDate = Time.get_datetime_dict_from_unix_time(newUnixTime)
	
	_refresh_calendar()

func _on_next_week_button_pressed() -> void:
	var newUnixTime = Time.get_unix_time_from_datetime_dict(selectedDate) + 7 * GlobalData.DAY_IN_UNIX_TIME
	selectedDate = Time.get_datetime_dict_from_unix_time(newUnixTime)
	
	_refresh_calendar()
