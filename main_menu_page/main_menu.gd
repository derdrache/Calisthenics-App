extends Control

@export var initalPage = 0

func _ready():
	%WorkoutButton.pressed.connect(_open_page.bind(0))
	%SkillTreeButton.pressed.connect(_open_page.bind(1))
	%StatisticButton.pressed.connect(_open_page.bind(2))
	
	_open_page(initalPage)

	
func _open_page(pageNumber):
	for i in %PageContainer.get_child_count():
		%PageContainer.get_children()[i].visible = i == pageNumber


