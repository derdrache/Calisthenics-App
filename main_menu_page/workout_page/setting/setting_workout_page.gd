extends Control

@export var selectedWorkout: WorkoutResource

@onready var modus_button: Button = %ModusButton
@onready var global_break_button: Button = %GlobalBreakButton
@onready var scroll_container: ScrollContainer = %ScrollContainer
@onready var exercise_container: VBoxContainer = %ExerciseContainer
@onready var save_workout_button: Button = %SaveWorkoutButton
@onready var name_input_box: LineEdit = %NameInputBox
@onready var circle_button: Button = %CircleButton

const EXERCISE_BOX = preload("res://main_menu_page/workout_page/setting/exercise_box.tscn")
const LABEL_SELECTION_CARUSEL = preload("res://widgets/selection_carusel/label_selection_carusel.tscn")

var globalBreakTime : int = GlobalData.initialBreakTime
var workoutModus: GlobalData.workout_modus = GlobalData.workout_modus.NORMAL
var circles: int = 1

func _ready() -> void:
	circle_button.hide()
	
	_load_workout()
	
	modus_button.title = "Modus:"
	modus_button.selectionList = GlobalData.workout_modus.keys()
	modus_button.initialValue = workoutModus
	modus_button.changed.connect(_change_modus)
	
	global_break_button.title = "Global Break Time"
	global_break_button.initialValue = globalBreakTime
	global_break_button.maxValue = 600
	global_break_button.steps = 30
	global_break_button.changed.connect(_change_break_time)
	
	circle_button.title = "Circles"
	circle_button.maxValue = 20
	circle_button.initialValue = circles
	circle_button.changed.connect(_change_circle_value)

	save_workout_button.pressed.connect(_save_workout)
	
	_add_exercise()
	
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

func _change_break_time(newValue: String) -> void:
	globalBreakTime = int(newValue)
	
	for container: Control in exercise_container.get_children():		
		container.change_break_time(globalBreakTime)

func _change_modus(newValue: String) -> void:
	var newModus: GlobalData.workout_modus = GlobalData.workout_modus[newValue]
	workoutModus = newModus
	
	_reset_modus_setup()
	
	_setup_modus(newModus)
	
func _setup_modus(modus: GlobalData.workout_modus) -> void:
	if modus == GlobalData.workout_modus.SUPERSET:
		_setup_superset_setup()
	if modus == GlobalData.workout_modus.CIRCLE:
		_setup_circle_modus()

func _reset_modus_setup() -> void:
	circle_button.hide()

func _setup_superset_setup() -> void:
	var childCount: int = exercise_container.get_child_count()
	var isOdd: bool = childCount / 2 == 0

	if not isOdd: 
		return
	
	_add_exercise()

func _setup_circle_modus() -> void:
	circle_button.show()

func _change_circle_value(newValue: String) -> void:
	circles = int(newValue)

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
	workoutData.circles = circles

		
	SaveAndLoad.save_resource(GlobalData.SAVE_WORKOUT_PATH, workoutData, workoutData.id)
	
	_on_top_navigation_bar_previous_page()

func _load_workout() -> void:
	if not selectedWorkout:
		return
	
	workoutModus = selectedWorkout.modus
	_setup_modus(workoutModus)
	globalBreakTime = selectedWorkout.globalBreak
	circles = selectedWorkout.circles
	
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
	
	await get_tree().create_timer(0.01).timeout
	
	scroll_container.set_deferred("scroll_vertical", scroll_container.get_v_scroll_bar().max_value)
