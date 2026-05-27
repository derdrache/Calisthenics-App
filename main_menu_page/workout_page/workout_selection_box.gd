extends PanelContainer

signal selected(workout: WorkoutResource)

@export var workout: WorkoutResource

@onready var label: Label = $MarginContainer/Label

func _ready() -> void:
	label.text = workout.workoutName

func _on_button_pressed() -> void:
	selected.emit(workout)
