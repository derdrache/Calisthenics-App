extends MarginContainer

func _ready() -> void:
	var pushData = StrengthSystem.get_push_data()
	var pullData = StrengthSystem.get_pull_data()
	var legData = StrengthSystem.get_leg_data()
	var coreData = StrengthSystem.get_core_Data()
	
	%AllStrengthLabel.text = str(StrengthSystem.get_overall_strength())
	%PushStrengthLabel.text = "Level " + str(pushData.level) +": " + str(pushData.strength)
	%PullStrengthLabel.text = "Level " + str(pullData.level) +": " + str(pullData.strength)
	%LegStrengthLabel.text = "Level " + str(legData.level) +": " + str(legData.strength)
	%CoreStrengthLabel.text = "Level " + str(coreData.level) +": " + str(coreData.strength)
