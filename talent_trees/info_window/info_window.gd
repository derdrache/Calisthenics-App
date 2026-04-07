extends PanelContainer

@onready var titleLabel: Label = %titleLabel
@onready var total_reps_label: Label = %totalRepsLabel
@onready var total_sets_label: Label = %totalSetsLabel
@onready var max_rep_label: Label = %maxRepLabel
@onready var best_reuslt_label: Label = %bestReusltLabel

@export var exerciseHistory: Exercise_History
@export var title: String

func _ready() -> void:
	add_to_group("infoWindow")
	
	titleLabel.text = title
	total_reps_label.text = str(exerciseHistory.totalReps)
	total_sets_label.text = str(exerciseHistory.totalSets)
	max_rep_label.text = str(exerciseHistory.maxRep)
	best_reuslt_label.text = ", ".join(exerciseHistory.bestResult)
	
func _input(event: InputEvent) -> void:
	var leftClick = Input.is_action_just_pressed("leftMouseClick")
	
	if not leftClick: 
		return
		
	var onWindow := get_global_rect().has_point(event.position)
	
	if not onWindow:
		queue_free()
	
	
