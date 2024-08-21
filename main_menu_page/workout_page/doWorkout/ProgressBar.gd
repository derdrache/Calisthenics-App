extends ProgressBar

signal countDownDone

func _ready():
	$Label.text = GlobalData.seconds_in_minutes_string(max_value)

func _on_timer_timeout():
	value += 1
	
	$Label.text = GlobalData.seconds_in_minutes_string(max_value - value)
	
	if value == max_value: 
		countDownDone.emit()		
