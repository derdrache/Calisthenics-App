extends MarginContainer

@onready var all_strength_label: Label = %AllStrengthLabel
@onready var push_strength_label: Label = %PushStrengthLabel
@onready var pull_strength_label: Label = %PullStrengthLabel
@onready var leg_strength_label: Label = %LegStrengthLabel
@onready var core_strength_label: Label = %CoreStrengthLabel


func _ready() -> void:
	var pushData := LevelSystem.get_push_data()
	var pullData := LevelSystem.get_pull_data()
	var legData := LevelSystem.get_leg_data()
	var coreData := LevelSystem.get_core_Data()
	
	all_strength_label.text = str(LevelSystem.get_overall_strength())
	push_strength_label.text = "Level " + str(pushData.level) +": " + str(pushData.strength)
	pull_strength_label.text = "Level " + str(pullData.level) +": " + str(pullData.strength)
	leg_strength_label.text = "Level " + str(legData.level) +": " + str(legData.strength)
	core_strength_label.text = "Level " + str(coreData.level) +": " + str(coreData.strength)
