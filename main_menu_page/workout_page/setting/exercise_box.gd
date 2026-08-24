extends Control
class_name ExerciseBox

signal changed()

@onready var letter_number: Label = %LetterNumber
@onready var talent_selection: TalentSelectionButton = %TalentSelection
@onready var set_selection: Button = %SetSelection
@onready var rep_selection: Button = %RepSelection
@onready var break_time_selection: Button = %BreakTimeSelection
@onready var close_button: TextureButton = %closeButton

@export var selectedTalent : TalentResource
@export var sets := 3
@export var reps := 5
@export var breakTime := GlobalData.initialBreakTime

const SELECTION_CARUSEL = preload("res://widgets/selection_carusel/label_selection_carusel.tscn")

func _ready() -> void:
	set_selection.title = "Sets"
	set_selection.maxValue = 10
	set_selection.initialValue = int(sets)
	set_selection.changed.connect(_change_sets_value)
	
	rep_selection.title = "Reps"
	rep_selection.maxValue = 99
	rep_selection.initialValue = int(reps)
	rep_selection.changed.connect(_change_reps_value)
	
	break_time_selection.title = "Break Time"
	break_time_selection.maxValue = 600
	break_time_selection.initialValue = int(breakTime)
	break_time_selection.steps = 30
	break_time_selection.changed.connect(_change_break_time)
	
	talent_selection.talent_updated.connect(_set_talent)
	close_button.pressed.connect(queue_free)
	
	if selectedTalent: _set_talent(selectedTalent)

func _process(_delta: float) -> void:
	letter_number.text = GlobalData.ABC_LIST[get_index()]

func _change_sets_value(newValue: String) -> void:
	sets = int(newValue)

	changed.emit()

func _change_reps_value(newValue: String) -> void:
	reps = int(newValue)
	
	changed.emit()

func _change_break_time(newValue: int) -> void:
	breakTime = newValue
	
	changed.emit()

func _set_talent(talent: TalentResource) -> void:
	selectedTalent = talent
	talent_selection.set_talent(selectedTalent, false)

func change_break_time(newValue: int) -> void:
	breakTime = newValue
	break_time_selection.initialValue = newValue
