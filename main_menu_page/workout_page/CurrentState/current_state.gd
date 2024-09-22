extends MarginContainer

func _ready() -> void:
	var pushData = LevelSystem.get_push_data()
	var pullData = LevelSystem.get_pull_data()
	var legData = LevelSystem.get_leg_data()
	var coreData = LevelSystem.get_core_Data()
	
	%AllStrengthLabel.text = str(LevelSystem.get_overall_strength())
	%PushStrengthLabel.text = "Level " + str(pushData.level) +": " + str(pushData.strength)
	%PullStrengthLabel.text = "Level " + str(pullData.level) +": " + str(pullData.strength)
	%LegStrengthLabel.text = "Level " + str(legData.level) +": " + str(legData.strength)
	%CoreStrengthLabel.text = "Level " + str(coreData.level) +": " + str(coreData.strength)
