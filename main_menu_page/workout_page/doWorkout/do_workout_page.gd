extends Control

var currentExcersice = GlobalWorkout.get_current_exersice()

func _ready():
	%ContinueButton.pressed.connect(_next_step)
	
	%CurrentExersiceLabel.text = currentExcersice.talent.get_talent_name()
	
	var currentSet = GlobalWorkout.get_current_set()
	var maxSet = GlobalWorkout.get_current_max_set()
	%SetInformationLabel.text = "Set: " + str(currentSet) + " / " + str(maxSet)

func _next_step():
	GlobalWorkout.next_exersice()
	get_tree().change_scene_to_file("res://main_menu_page/workout_page/doWorkout/break_page.tscn")
	
