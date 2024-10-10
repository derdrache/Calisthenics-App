extends ProgressBar

signal countDownDone()

@onready var label: Label = $Label

func _ready() -> void:
	label.text = GlobalData.seconds_in_minutes_string(max_value)

func _on_timer_timeout() -> void:
	value += 1
	
	label.text = GlobalData.seconds_in_minutes_string(max_value - value)
	
	if value == max_value: 
		countDownDone.emit()		
