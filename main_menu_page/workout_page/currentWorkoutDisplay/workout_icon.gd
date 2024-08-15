extends Control

@export var exersiceName = ""

func _ready():
	%ExerciseNameLabel.text = exersiceName
	%ExcersieLetterLabel.text = GlobalData.abcList[get_index()]
