extends Button

signal changed(newValue)

@export var title: String:
	set(value):
		title = value
		text = title
@export var initialValue: int:
	set(value):
		initialValue = value
		if selectionList:
			text = title + "\n" + selectionList[initialValue]
		else:
			text = title + "\n" + str(initialValue)
@export var selectionList: Array
@export_category("Number Selection")
@export var maxValue: int
@export var steps := 1


const LABEL_SELECTION_CARUSEL = preload("res://widgets/selection_carusel/label_selection_carusel.tscn")

func _ready() -> void:	
	pressed.connect(_show_selection_window)

func _show_selection_window() -> void:
	var selectionCaruselNode: LabelSelectionCarusel = LABEL_SELECTION_CARUSEL.instantiate()
	
	selectionCaruselNode.title = title
	selectionCaruselNode.stringList = selectionList
	selectionCaruselNode.initialValue = initialValue
	selectionCaruselNode.maxValue = maxValue
	selectionCaruselNode.steps = steps

	add_child(selectionCaruselNode)
	
	selectionCaruselNode.global_position = global_position + size / 2 - selectionCaruselNode.size / 2.0
	selectionCaruselNode.valueChanged.connect(_on_carusel_value_changed)
	
func _on_carusel_value_changed(value: String) -> void:
	if selectionList:
		initialValue = selectionList.find(value)
	else:
		initialValue = int(value)
	changed.emit(value)
