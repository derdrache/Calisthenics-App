extends Control

@export var selectedWorkout: WorkoutResource

@onready var modus_button: Button = %ModusButton
@onready var global_break_button: Button = %GlobalBreakButton
@onready var scroll_container: ScrollContainer = %ScrollContainer
@onready var exercise_container: VBoxContainer = %ExerciseContainer
@onready var save_workout_button: Button = %SaveWorkoutButton
@onready var name_input_box: LineEdit = %NameInputBox

const EXERCISE_BOX = preload("res://main_menu_page/workout_page/setting/exercise_box.tscn")
const LABEL_SELECTION_CARUSEL = preload("res://widgets/selection_carusel/label_selection_carusel.tscn")

var globalBreakTime : int = GlobalData.initialBreakTime
var workoutModus: GlobalData.workout_modus = GlobalData.workout_modus.NORMAL

func _ready() -> void:
	modus_button.pressed.connect(_set_modus_window)
	global_break_button.pressed.connect(_set_break_window)
	save_workout_button.pressed.connect(_save_workout)
	
	_refresh_modus_button_label()
	_refresh_global_break_button_label()
	
	_add_exercise()
	
	_load_workout()
	
func _refresh_modus_button_label() -> void:
	modus_button.text = "Modus:\n" + GlobalData.workout_modus.keys()[workoutModus]
	
func _refresh_global_break_button_label() -> void:
	global_break_button.text = "Break:\n" + str(globalBreakTime) + " sec"
	
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
	
	var workoutData: WorkoutResource = WorkoutResource.new()
	
	if selectedWorkout:
		workoutData = selectedWorkout
	else:
		workoutData.id = WorkoutResource.generate_scene_unique_id()	
		
	workoutData.workoutName = name_input_box.text
	workoutData.modus = workoutModus
	workoutData.globalBreak = globalBreakTime
	workoutData.exercises = _get_all_exersice_data()

		
	SaveAndLoad.save_resource(GlobalData.SAVE_WORKOUT_PATH, workoutData, workoutData.id)
	
	_on_top_navigation_bar_previous_page()

func _load_workout() -> void:
	if not selectedWorkout:
		return
		
	exercise_container.get_children()[0].queue_free()
	
	workoutModus = selectedWorkout.modus
	globalBreakTime = selectedWorkout.globalBreak
	
	_refresh_modus_button_label()
	_refresh_global_break_button_label()
	
	name_input_box.text = selectedWorkout.workoutName

	for exercise: Exercise in selectedWorkout.exercises:
		var exerciseNode: ExerciseBox = EXERCISE_BOX.instantiate()
		exerciseNode.breakTime = exercise.breakTime
		exerciseNode.reps = exercise.reps
		exerciseNode.sets = exercise.maxSets
		exerciseNode.selectedTalent = exercise.talent
		
		exercise_container.add_child(exerciseNode)
		exercise_container.move_child(exerciseNode, exercise_container.get_child_count() -2)
		
		exercise.talent.get_talent_level()

func _on_top_navigation_bar_previous_page() -> void:
	get_tree().change_scene_to_file("res://main_menu_page/workout_page/select_workout_page/select_workout_page.tscn")

func _on_add_button_pressed() -> void:
	_add_exercise()
