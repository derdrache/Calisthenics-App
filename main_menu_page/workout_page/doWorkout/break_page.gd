extends Control

func _ready():
	%CountDownBar.countDownDone.connect(_next_exersice)
	%ContinueButton.pressed.connect(_next_exersice)
	
	var breakTime = GlobalWorkout.get_break_time()
	%BreakLengthLabel.text = str(breakTime) + " sec"
	%CountDownBar.max_value = breakTime
	
	var nextExersice = GlobalWorkout.get_current_exercise().talent
	%WorkoutIcon.set_talent(nextExersice)
	
func _next_exersice():
	get_tree().change_scene_to_file("res://main_menu_page/workout_page/doWorkout/do_workout_page.tscn")
