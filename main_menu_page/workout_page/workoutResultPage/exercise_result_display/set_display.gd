extends HBoxContainer
class_name ExerciseDoneDisplay

@onready var progress_bar: ProgressBar = %ProgressBar
@onready var set_label: Label = %SetLabel
@onready var progress_label: Label = %ProgressLabel


var reps: int
var goal: int

func _ready() -> void:
	set_label.text = "Set " + str(get_index() +1)
	
	progress_bar.value = reps
	progress_bar.max_value = goal
	
	progress_label.text = str(reps) + " / " + str(goal)
