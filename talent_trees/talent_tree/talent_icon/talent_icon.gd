@tool
extends Panel

@export var talentResource : TalentResource:
	set(newValue):
		talentResource = newValue
		
		if not label: return
		
		if newValue == null: label.text = ""
		else:
			var talentName = talentResource.resource_path.get_file().trim_suffix('.tres')
			label.text = talentName.replace("_", " ")
@export var isGoal = false

@export var lockColorPanel : Color
@export var lockColorBorder: Color

@export var unlockColorPanel: Color
@export var unlockColorBorder : Color

@onready var label = $Label
@onready var texture_rect = $TextureRect
@onready var goal_icon = $GoalIcon
@onready var button = %Button


const TALENT_ICON_STYLEBOX = preload("res://talent_trees/talent_tree/talent_icon/talent_icon_stylebox.tres")

func _ready():
	goal_icon.hide()
	
	if talentResource: add_to_group("talents")
	
	if not talentResource: 
		texture_rect.hide()
		add_theme_stylebox_override("panel", StyleBoxEmpty.new())
		return
	else:
		add_theme_stylebox_override("panel", TALENT_ICON_STYLEBOX)
	
	if not talentResource.icon: texture_rect.hide()
	
	var talentName = talentResource.resource_path.get_file().trim_suffix('.tres')
	label.text = talentName.replace("_", " ")
	
	if isGoal: goal_icon.show()
	
	_set_style()
		


func get_center():
	return custom_minimum_size/2

func _set_style():
	var styleBox : StyleBoxFlat = get_theme_stylebox("panel").duplicate()
	
	if talentResource.is_unlocked:
		styleBox.border_color = unlockColorBorder
		styleBox.bg_color = unlockColorPanel
	else:
		styleBox.border_color = lockColorBorder
		styleBox.bg_color = lockColorPanel		
	
	add_theme_stylebox_override("panel", styleBox)
	
