extends Control

@onready var exercise_container = %ExerciseContainer
@onready var scroll_container = %ScrollContainer

const MAIN_MENU = preload("res://main_menu_page/main_menu.tscn")
const EXERCISE_BOX = preload("res://main_menu_page/workout_page/setting/exercise_box.tscn")
const LABEL_SELECTION_CARUSEL = preload("res://widgets/selection_carusel/label_selection_carusel.tscn")

var globalBreakTime : int = GlobalData.initialBreakTime
var workoutModus = GlobalData.workoutModus[0]

func _ready():
	%ModusButton.pressed.connect(_set_modus_window)
	%GlobalBreakButton.pressed.connect(_set_break_window)
	%addExerciseButton.pressed.connect(_add_exercise)
	%SaveWorkoutButton.pressed.connect(_save_workout)
	
	_load_workout()
	
	_refresh_modus_button_label()
	_refresh_global_break_button_label()

func _refresh_modus_button_label():
	
	%ModusButton.text = "Modus:\n" + workoutModus
	
func _refresh_global_break_button_label():
	%GlobalBreakButton.text = "Break:\n" + str(globalBreakTime) + " sec"

func _on_top_navigation_bar_previous_page():
	var mainMenu = MAIN_MENU.instantiate()
	
	mainMenu.initalPage = 0

	get_tree().current_scene.queue_free()
	get_tree().root.add_child(mainMenu)
	get_tree().current_scene = mainMenu

func _save_workout():
	if _get_all_exersice_data().is_empty(): return
	
	var workoutData = {
		"name":  "Workout_A",
		"modus": workoutModus,
		"globalBreak": globalBreakTime,
		"exercises": _get_all_exersice_data()
	} 
	
	GlobalWorkout.save_workout(workoutData)
	
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
	exerciseNode.breakTime = globalBreakTime
	
	exercise_container.add_child(exerciseNode)
	exercise_container.move_child(exerciseNode, exercise_container.get_child_count() -2)
	
	_scroll_v_bottom()
	
func _scroll_v_bottom():
	await get_tree().process_frame
	await get_tree().process_frame
	var vScrollbar = scroll_container.get_v_scroll_bar()
	scroll_container.scroll_vertical = vScrollbar.max_value

func _set_break_window():
	var selectionCaruselNode = LABEL_SELECTION_CARUSEL.instantiate()
	selectionCaruselNode.title = "Global Break Time"
	selectionCaruselNode.maxValue = 600
	selectionCaruselNode.initialValue = int(globalBreakTime)
	selectionCaruselNode.steps = 30
	
	add_child(selectionCaruselNode)
	selectionCaruselNode.global_position = %GlobalBreakButton.global_position
	
	selectionCaruselNode.valueChanged.connect(_change_break_time)

func _change_break_time(newValue):
	globalBreakTime = int(newValue)
	_refresh_global_break_button_label()
	
	for container in exercise_container.get_children():
		if "Button" in container.name: continue
		
		container.change_break_time(globalBreakTime)

func _set_modus_window():
	var selectionCaruselNode = LABEL_SELECTION_CARUSEL.instantiate()
	selectionCaruselNode.title = "Workout Modus"
	selectionCaruselNode.stringList = GlobalData.workoutModus
	selectionCaruselNode.initialValue = workoutModus

	add_child(selectionCaruselNode)
	selectionCaruselNode.global_position = %ModusButton.global_position
	selectionCaruselNode.valueChanged.connect(_change_modus)	

func _change_modus(newValue):
	workoutModus = newValue
	_refresh_modus_button_label()

func _load_workout():
	var workoutData = GlobalWorkout.currentWorkout
	
	if not workoutData: return
	
	exercise_container.get_children()[0].queue_free()
	
	workoutModus = workoutData.modus
	globalBreakTime = workoutData.globalBreak
	
	_refresh_modus_button_label()
	_refresh_global_break_button_label()
	
	for exercise in workoutData.exercises:
		var exerciseNode = EXERCISE_BOX.instantiate()
		exerciseNode.breakTime = exercise.breakTime
		exerciseNode.reps = exercise.reps
		exerciseNode.sets = exercise.sets
		exerciseNode.selectedTalent = exercise.talent
		
		exercise_container.add_child(exerciseNode)
		exercise_container.move_child(exerciseNode, exercise_container.get_child_count() -2)
		
		exercise.talent.get_talent_level()
	
