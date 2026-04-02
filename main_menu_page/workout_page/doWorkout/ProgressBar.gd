extends ProgressBar

signal countDownDone()

@onready var label: Label = $Label

@export var countdown: int:
	set(value):
		countdown = value
		max_value = value
		if is_node_ready():
			label.text = str(value)

func _on_timer_timeout() -> void:
	value += 1
	
	label.text = str(int(max_value - value))
	
	if value == max_value: 
		countDownDone.emit()		
