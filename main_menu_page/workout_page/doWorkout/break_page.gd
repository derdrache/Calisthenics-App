extends Control

@onready var break_length_label: Label = %BreakLengthLabel
@onready var talent_selection: TalentSelectionButton = %TalentSelection
@onready var count_down_bar: ProgressBar = %CountDownBar
@onready var continue_button: Button = %ContinueButton

func _ready() -> void:
	count_down_bar.countDownDone.connect(_next_exersice)
	continue_button.pressed.connect(_next_exersice)
	
	var breakTime: int = WorkoutManager.get_break_time()
	break_length_label.text = str(breakTime) + " sec"
	count_down_bar.max_value = breakTime
	
	var nextExersice: TalentResource = WorkoutManager.get_current_exercise().talent
	talent_selection.set_talent(nextExersice)
	
func _next_exersice() -> void:
	get_tree().change_scene_to_file("res://main_menu_page/workout_page/doWorkout/do_workout_page.tscn")
