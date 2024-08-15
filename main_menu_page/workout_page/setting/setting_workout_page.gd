extends Control

@onready var exercise_container = %ExerciseContainer
@onready var scroll_container = %ScrollContainer

const MAIN_MENU = preload("res://main_menu_page/main_menu.tscn")
const EXERCISE_BOX = preload("res://main_menu_page/workout_page/setting/exercise_box.tscn")

const WORKOUT_A = preload("res://resrouces/workout_resources/Workout_A.tres")

func _ready():
	%addExerciseButton.pressed.connect(_add_exercise)
	%SaveWorkoutButton.pressed.connect(_save_workout)

func _on_top_navigation_bar_previous_page():
	var mainMenu = MAIN_MENU.instantiate()
	
	mainMenu.initalPage = 0

	get_tree().current_scene.queue_free()
	get_tree().root.add_child(mainMenu)
	get_tree().current_scene = mainMenu

func _save_workout():
	var workoutData = _get_all_exersice_data()
	WORKOUT_A.workoutName = "Test"
	WORKOUT_A.exersices = workoutData
	
	SaveAndLoad.save_resource(WORKOUT_A)
	
	_on_top_navigation_bar_previous_page()
	

func _get_all_exersice_data():
	var exerciseList = []
	
	for exerciseBox in exercise_container.get_children():
		if "Button" in exerciseBox.name: continue
		
		var newExercise = {
			"talent": exerciseBox.selectedTalent,
			"sets": exerciseBox.sets,
			"reps": exerciseBox.reps,
			"breakTime": exerciseBox.breakTime
		}
		
		if newExercise.talent: exerciseList.append(newExercise)
	
	return exerciseList

func _add_exercise():
	var exerciseNode = EXERCISE_BOX.instantiate()
	
	exercise_container.add_child(exerciseNode)
	exercise_container.move_child(exerciseNode, exercise_container.get_child_count() -2)
	
	_scroll_v_bottom()
	
func _scroll_v_bottom():
	await get_tree().process_frame
	await get_tree().process_frame
	var vScrollbar = scroll_container.get_v_scroll_bar()
	scroll_container.scroll_vertical = vScrollbar.max_value
