extends Control

@export var talent : TalentResource

func _ready():
	if not talent: return
	
	_set_label()

func _set_label():
	%ExerciseNameLabel.text = talent.get_talent_name()
	%ExcersieLetterLabel.text = GlobalData.abcList[get_index()]

func set_talent(newTalent):
	talent = newTalent
	
	_set_label()
