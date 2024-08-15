extends HBoxContainer

@onready var progress_bar = %ProgressBar

var reps: int
var goal: int

func _ready():
	%SetLabel.text = "Set " + str(get_index() +1)
	
	progress_bar.value = reps
	progress_bar.max_value = goal
	
	%ProgressLabel.text = str(reps) + " / " + str(goal)
