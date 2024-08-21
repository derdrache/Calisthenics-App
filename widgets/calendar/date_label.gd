extends MarginContainer

@export var date: Dictionary

func _ready() -> void:
	%DateLabel.text = str(date.day)
	
	var currentDate = Time.get_datetime_dict_from_system()
	var isCurrentDate = date.day == currentDate.day and date.month == currentDate.month and date.year == currentDate.year

	
	if not isCurrentDate:%Panel.add_theme_stylebox_override("panel", StyleBoxEmpty.new())


func _on_button_pressed() -> void:
	print(date)
