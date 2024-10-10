extends Button
class_name TalentSelectionButton

signal talent_updated

@export var withTalentSelection := true
@export var small := false

@onready var buttons_container: Control = %ButtonsContainer
@onready var label: Label= %Label
@onready var exercise_level_label: Label= %ExerciseLevelLabel

var radius := 90.0
var animationSpeed := 0.25
var smallSize := Vector2(125,125)

var num: int
var active := false

func _ready() -> void:
	buttons_container.hide()
	
	if small: 
		custom_minimum_size = smallSize
		size = smallSize
	
	num = buttons_container.get_child_count()
	for button: Button in buttons_container.get_children():
		button.global_position = global_position + get_rect().size / 2
		button.pressed.connect(_show_talent_tree.bind(button.text))


func _on_pressed() -> void:
	if not withTalentSelection: return
	disabled = true

	if active:
		_hide_menu()
	else:
		_show_menu()

func _show_menu() -> void:
	var spacing := TAU / buttons_container.get_child_count()
	
	for button: Button in buttons_container.get_children():
		var angle := spacing * button.get_index() - PI
		var targetDirection := Vector2(radius, 0).rotated(angle)
		var targetPosition: Vector2 = button.global_position - button.get_rect().size + targetDirection
		
		var tween := get_tree().create_tween()
		tween.tween_property(button, "global_position", targetPosition, animationSpeed).set_trans(
			Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		tween.parallel()
		tween.tween_property(button, "scale", Vector2.ONE, animationSpeed).set_trans(Tween.TRANS_LINEAR)
	
	await get_tree().create_timer(animationSpeed).timeout
	
	disabled = false
	active = true
		
	buttons_container.show()

func _hide_menu() -> void:
	for button in buttons_container.get_children():
		var tween := get_tree().create_tween()
		tween.tween_property(button, "global_position", global_position + get_rect().size / 2, animationSpeed).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
		tween.parallel()
		tween.tween_property(button, "scale",  Vector2(0.5, 0.5), animationSpeed).set_trans(Tween.TRANS_LINEAR)
		
	await get_tree().create_timer(animationSpeed).timeout
	disabled = false
	active = false
	buttons_container.hide()

func _show_talent_tree(talentGroup: String) -> void:
	_hide_menu()
	
	var talentNode: TalentTree
	
	if talentGroup == "PUSH":
		talentNode = load("res://talent_trees/push_talent_tree.tscn").instantiate()
	elif talentGroup == "PULL":
		talentNode = load("res://talent_trees/pull_talent_tree.tscn").instantiate()
	elif talentGroup == "CORE":
		talentNode = load("res://talent_trees/core_talent_tree.tscn").instantiate()
	elif talentGroup == "LEG":
		talentNode = load("res://talent_trees/leg_talent_tree.tscn").instantiate()

	talentNode.talentSelection = true
	talentNode.selected_talent.connect(set_talent)
	add_child(talentNode)

func set_talent(talent : TalentResource, withSignal := true) -> void:
	label.text = talent.get_talent_name()
	exercise_level_label.text = talent.get_talent_level()
	if withSignal: talent_updated.emit(talent)
	
