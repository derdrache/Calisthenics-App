extends Control
class_name ExerciseBox

@onready var letter_number: Label = %LetterNumber
@onready var talent_selection: TalentSelectionButton = %TalentSelection
@onready var set_selection: Button = %SetSelection
@onready var rep_selection: Button = %RepSelection
@onready var break_time_selection: Button = %BreakTimeSelection
@onready var delete_button: Button = %DeleteButton


@export var selectedTalent : TalentResource
@export var sets := 3
@export var reps := 5
@export var breakTime := GlobalData.initialBreakTime

const SELECTION_CARUSEL = preload("res://widgets/selection_carusel/label_selection_carusel.tscn")

func _ready() -> void:
	set_selection.pressed.connect(_set_sets_window)
	rep_selection.pressed.connect(_set_reps_window)
	break_time_selection.pressed.connect(_set_break_window)
	talent_selection.talent_updated.connect(_set_talent)
	delete_button.pressed.connect(queue_free)
	
	if selectedTalent: _set_talent(selectedTalent)
	
	_refresh_sets_label()
	_refresh_reps_label()
	_refresh_break_time_label()

func _process(_delta: float) -> void:
	letter_number.text = GlobalData.ABC_LIST[get_index()]

func _refresh_sets_label() -> void:
	set_selection.text = str(sets) + " Sets"

func _refresh_reps_label() -> void:
	rep_selection.text = str(reps) + " Reps"

func _refresh_break_time_label() -> void:
		break_time_selection.text = str(breakTime)+ " sec"

func _set_sets_window() -> void:
	var selectionCaruselNode: LabelSelectionCarusel = SELECTION_CARUSEL.instantiate()
	selectionCaruselNode.title = "Sets"
	selectionCaruselNode.maxValue = 10
	selectionCaruselNode.initialValue = int(sets)
	
	add_child(selectionCaruselNode)
	selectionCaruselNode.valueChanged.connect(_change_sets_value)
	
func _change_sets_value(newValue: int) -> void:
	sets = newValue
	_refresh_sets_label()

func _set_reps_window() -> void:
	var selectionCaruselNode: LabelSelectionCarusel = SELECTION_CARUSEL.instantiate()
	selectionCaruselNode.title = "Reps"
	selectionCaruselNode.maxValue = 99
	selectionCaruselNode.initialValue = int(reps)
	
	add_child(selectionCaruselNode)
	selectionCaruselNode.valueChanged.connect(_change_reps_value)	

func _change_reps_value(newValue: int) -> void:
	reps = newValue
	_refresh_reps_label()

func _set_break_window() -> void:
	var selectionCaruselNode: LabelSelectionCarusel = SELECTION_CARUSEL.instantiate()
	selectionCaruselNode.title = "Break Time"
	selectionCaruselNode.maxValue = 600
	selectionCaruselNode.initialValue = int(breakTime)
	selectionCaruselNode.steps = 30
	
	add_child(selectionCaruselNode)
	selectionCaruselNode.valueChanged.connect(_change_break_time)

func _change_break_time(newValue: int) -> void:
	breakTime = newValue
	_refresh_break_time_label()

func _set_talent(talent: TalentResource) -> void:
	selectedTalent = talent
	talent_selection.set_talent(selectedTalent, false)

func change_break_time(newValue: int) -> void:
	breakTime = newValue
	_refresh_break_time_label()
