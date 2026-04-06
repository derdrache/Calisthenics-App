extends Control

@onready var modus_button: Button = %ModusButton
@onready var global_break_button: Button = %GlobalBreakButton
@onready var scroll_container: ScrollContainer = %ScrollContainer
@onready var exercise_container: VBoxContainer = %ExerciseContainer
@onready var add_exercise_button: Button = %addExerciseButton
@onready var save_workout_button: Button = %SaveWorkoutButton

const MAIN_MENU = preload("res://main_menu_page/main_menu.tscn")
const EXERCISE_BOX = preload("res://main_menu_page/workout_page/setting/exercise_box.tscn")
const LABEL_SELECTION_CARUSEL = preload("res://widgets/selection_carusel/label_selection_carusel.tscn")

var globalBreakTime : int = GlobalData.initialBreakTime
var workoutModus: GlobalData.workout_modus = GlobalData.workout_modus.NORMAL

func _ready() -> void:
	modus_button.pressed.connect(_set_modus_window)
	global_break_button.pressed.connect(_set_break_window)
	add_exercise_button.pressed.connect(_add_exercise)
	save_workout_button.pressed.connect(_save_workout)
	
	_refresh_modus_button_label()
	_refresh_global_break_button_label()
	
	_add_exercise()
	
	_load_workout()

func _refresh_modus_button_label() -> void:
	modus_button.text = "Modus:\n" + GlobalData.workout_modus.keys()[workoutModus]
	
func _refresh_global_break_button_label() -> void:
	global_break_button.text = "Break:\n" + str(globalBreakTime) + " sec"

func _on_top_navigation_bar_previous_page() -> void:
	var mainMenu: MainMenu = MAIN_MENU.instantiate()
	
	mainMenu.initalPage = 0

	get_tree().current_scene.queue_free()
	get_tree().root.add_child(mainMenu)
	get_tree().current_scene = mainMenu

func _get_all_exersice_data() -> Array[Exercise]:
	var exerciseList: Array[Exercise] = []
	
	for exerciseBox: Control in exercise_container.get_children():
		if "Button" in exerciseBox.name: continue
		
		var newExercise := Exercise.new()
		newExercise.talent = exerciseBox.selectedTalent
		newExercise.maxSets = exerciseBox.sets
		newExercise.reps = exerciseBox.reps
		newExercise.breakTime = exerciseBox.breakTime
		
		if newExercise.talent: exerciseList.append(newExercise)
	
	return exerciseList

func _add_exercise() -> void:
	var exerciseNode: ExerciseBox = EXERCISE_BOX.instantiate()
	exerciseNode.breakTime = globalBreakTime
	
	exercise_container.add_child(exerciseNode)
	
	exerciseNode.changed.connect(_on_exercise_container_changed.bind(exerciseNode))

	var childCount: int = exercise_container.get_child_count()
	var isOdd: bool = childCount / 2 == 0

	if not isOdd and workoutModus == GlobalData.workout_modus.SUPERSET:
		var secondExerciseNode: ExerciseBox = EXERCISE_BOX.instantiate()
		secondExerciseNode.breakTime = globalBreakTime
		
		exercise_container.add_child(secondExerciseNode)
		
		secondExerciseNode.changed.connect(_on_exercise_container_changed.bind(secondExerciseNode))
	
	_scroll_v_bottom()

func _on_exercise_container_changed(exercise_box: Control) -> void:
	if not workoutModus == GlobalData.workout_modus.SUPERSET:
		return
	
	var exerciseContainerIndex: int = exercise_box.get_index()
	var connectionContainerIndex := -1
	var isOddIndex:bool = exerciseContainerIndex / 2 == 0

	if isOddIndex:
		connectionContainerIndex = exerciseContainerIndex - 1
	else:
		connectionContainerIndex = exerciseContainerIndex + 1
		
	var connectionContainer: Control = exercise_container.get_child(connectionContainerIndex)
	connectionContainer.change_break_time(exercise_box.breakTime)
	connectionContainer.change_sets(exercise_box.sets)

func _scroll_v_bottom() -> void:
	await get_tree().process_frame
	await get_tree().process_frame
	var vScrollbar := scroll_container.get_v_scroll_bar()
	scroll_container.scroll_vertical = int(vScrollbar.max_value)

func _set_break_window() -> void:
	var selectionCaruselNode: LabelSelectionCarusel = LABEL_SELECTION_CARUSEL.instantiate()
	selectionCaruselNode.title = "Global Break Time"
	selectionCaruselNode.maxValue = 600
	selectionCaruselNode.initialValue = int(globalBreakTime)
	selectionCaruselNode.steps = 30
	
	add_child(selectionCaruselNode)
	selectionCaruselNode.global_position = global_break_button.global_position
	
	selectionCaruselNode.valueChanged.connect(_change_break_time)

func _change_break_time(newValue: String) -> void:
	globalBreakTime = int(newValue)
	_refresh_global_break_button_label()
	
	for container: Control in exercise_container.get_children():		
		container.change_break_time(globalBreakTime)

func _set_modus_window() -> void:
	var selectionCaruselNode: LabelSelectionCarusel = LABEL_SELECTION_CARUSEL.instantiate()
	
	selectionCaruselNode.title = "Workout Modus"
	selectionCaruselNode.stringList = GlobalData.workout_modus.keys()
	selectionCaruselNode.initialValue = workoutModus

	add_child(selectionCaruselNode)
	selectionCaruselNode.global_position = modus_button.global_position
	selectionCaruselNode.valueChanged.connect(_change_modus)	

func _change_modus(newValue: String) -> void:
	var newModus: GlobalData.workout_modus = GlobalData.workout_modus[newValue]
	workoutModus = newModus
	_refresh_modus_button_label()
	
	if newModus == GlobalData.workout_modus.SUPERSET:
		_check_superset_setup()
		
func _check_superset_setup() -> void:
	var childCount: int = exercise_container.get_child_count()
	var isOdd: bool = childCount / 2 == 0

	if not isOdd: 
		return
	
	_add_exercise()
	

func _save_workout() -> void:
	if _get_all_exersice_data().is_empty(): return
	
	var workoutData := WorkoutResource.new()
	workoutData.workoutName = "Workout_A"
	workoutData.modus = workoutModus
	workoutData.globalBreak = globalBreakTime
	workoutData.exercises = _get_all_exersice_data()

	if GlobalData.workouts.is_empty():
		GlobalData.workouts.append(workoutData)
	else:
		GlobalData.workouts[0] = workoutData
		
	SaveAndLoad.save_resource(GlobalData.SAVE_WORKOUT_PATH, workoutData, workoutData.workoutName)
	
	_on_top_navigation_bar_previous_page()

func _load_workout() -> void:
	if GlobalData.workouts.is_empty():
		return
		
	var workoutData := GlobalData.workouts[0]
	
	exercise_container.get_children()[0].queue_free()
	
	workoutModus = workoutData.modus
	globalBreakTime = workoutData.globalBreak
	
	_refresh_modus_button_label()
	_refresh_global_break_button_label()

	for exercise: Exercise in workoutData.exercises:
		var exerciseNode: ExerciseBox = EXERCISE_BOX.instantiate()
		exerciseNode.breakTime = exercise.breakTime
		exerciseNode.reps = exercise.reps
		exerciseNode.sets = exercise.maxSets
		exerciseNode.selectedTalent = exercise.talent
		
		exercise_container.add_child(exerciseNode)
		exercise_container.move_child(exerciseNode, exercise_container.get_child_count() -2)
		
		exercise.talent.get_talent_level()
	
