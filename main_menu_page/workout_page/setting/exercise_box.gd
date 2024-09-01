extends Control

@onready var set_selection = %SetSelection
@onready var rep_selection = %RepSelection
@onready var break_time_selection = %BreakTimeSelection
@onready var talent_selection = %TalentSelection

@export var selectedTalent : Resource
@export var sets = 3
@export var reps = 5
@export var breakTime = GlobalData.initialBreakTime

const SELECTION_CARUSEL = preload("res://widgets/selection_carusel/label_selection_carusel.tscn")

func _ready():
	set_selection.pressed.connect(_set_sets_window)
	rep_selection.pressed.connect(_set_reps_window)
	break_time_selection.pressed.connect(_set_break_window)
	talent_selection.talent_updated.connect(_set_talent)
	%DeleteButton.pressed.connect(queue_free)
	
	if selectedTalent: _set_talent(selectedTalent)
	
	_refresh_sets_label()
	_refresh_reps_label()
	_refresh_break_time_label()

func _process(delta):
	%LetterNumber.text = GlobalData.abcList[get_index()]

func _refresh_sets_label():
	set_selection.text = str(sets) + " Sets"

func _refresh_reps_label():
	rep_selection.text = str(reps) + " Reps"

func _refresh_break_time_label():
		break_time_selection.text = str(breakTime)+ " sec"

func _set_sets_window():
	var selectionCaruselNode = SELECTION_CARUSEL.instantiate()
	selectionCaruselNode.title = "Sets"
	selectionCaruselNode.maxValue = 10
	selectionCaruselNode.initialValue = int(sets)
	
	add_child(selectionCaruselNode)
	selectionCaruselNode.valueChanged.connect(_change_sets_value)
	
func _change_sets_value(newValue):
	sets = newValue
	_refresh_sets_label()

func _set_reps_window():
	var selectionCaruselNode = SELECTION_CARUSEL.instantiate()
	selectionCaruselNode.title = "Reps"
	selectionCaruselNode.maxValue = 99
	selectionCaruselNode.initialValue = int(reps)
	
	add_child(selectionCaruselNode)
	selectionCaruselNode.valueChanged.connect(_change_reps_value)	

func _change_reps_value(newValue):
	reps = newValue
	_refresh_reps_label()

func _set_break_window():
	var selectionCaruselNode = SELECTION_CARUSEL.instantiate()
	selectionCaruselNode.title = "Break Time"
	selectionCaruselNode.maxValue = 600
	selectionCaruselNode.initialValue = int(breakTime)
	selectionCaruselNode.steps = 30
	
	add_child(selectionCaruselNode)
	selectionCaruselNode.valueChanged.connect(_change_break_time)

func _change_break_time(newValue):
	breakTime = newValue
	_refresh_break_time_label()

func _set_talent(talent):
	selectedTalent = talent
	talent_selection.set_talent(selectedTalent, false)

func change_break_time(newValue):
	breakTime = newValue
	_refresh_break_time_label()
