extends ProgressBar

signal countDownDone

func _ready():
	$Label.text = _seconds_in_minutes_string(max_value)

func _on_timer_timeout():
	value += 1
	
	$Label.text = _seconds_in_minutes_string(max_value - value)
	
	if value == 0: countDownDone.emit()

func _seconds_in_minutes_string(seconds):
	var pufferMinutes = seconds / 60
	var minutes = int(pufferMinutes)
	var restSeconds = (pufferMinutes - minutes) * 60
	var spezialZero = "0" if restSeconds < 10 else ""
	
	return str(minutes) + ":" + spezialZero + str(round(restSeconds))
	
		
