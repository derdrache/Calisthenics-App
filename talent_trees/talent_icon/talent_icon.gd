extends Panel
class_name TalentIcon

@export var talentResource : TalentResource:
	set(newValue):
		talentResource = newValue
		
		if not label: return
		
		if newValue == null: label.text = ""
		else:
			var talentName: String = talentResource.resource_path.get_file().trim_suffix('.tres')
			label.text = talentName.replace("_", " ")
@export var isGoal := false

@export var lockColorPanel : Color
@export var lockColorBorder: Color

@export var unlockColorPanel: Color
@export var unlockColorBorder : Color

@export var completeColorPanel: Color
@export var completeColorBorder: Color

@onready var texture_rect: TextureRect = $TextureRect
@onready var label: Label = $Label
@onready var goal_icon: TextureRect = $GoalIcon
@onready var button: Button = %Button

const TALENT_ICON_STYLEBOX = preload("res://talent_trees/talent_icon/talent_icon_stylebox.tres")

func _ready() -> void:
	goal_icon.hide()
	
	if talentResource: 
		add_to_group("talents")
		talentResource = talentResource.load_save_data()
	
	if not talentResource: 
		texture_rect.hide()
		add_theme_stylebox_override("panel", StyleBoxEmpty.new())
		return
	else:
		add_theme_stylebox_override("panel", TALENT_ICON_STYLEBOX)
	
	if not talentResource.icon: texture_rect.hide()
	
	var talentName: String = talentResource.resource_path.get_file().trim_suffix('.tres')
	label.text = talentName.replace("_", " ")
	
	if isGoal: goal_icon.show()
	
	_set_style()
		


func get_center() -> Vector2:
	return custom_minimum_size/2

func _set_style() -> void:
	var styleBox : StyleBoxFlat = get_theme_stylebox("panel").duplicate()
	
	if talentResource.completed:
		styleBox.border_color = completeColorBorder
		styleBox.bg_color = completeColorPanel
	elif talentResource.is_unlocked:
		styleBox.border_color = unlockColorBorder
		styleBox.bg_color = unlockColorPanel
	else:
		styleBox.border_color = lockColorBorder
		styleBox.bg_color = lockColorPanel		
	
	add_theme_stylebox_override("panel", styleBox)
	


func _on_button_pressed() -> void:
	# open info window?
	pass
