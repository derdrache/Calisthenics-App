extends Button

signal talent_updated

@onready var buttons_container = %ButtonsContainer
@onready var label = %Label


var radius = 90
var animatinSpeed = 0.25

var num
var active = false

func _ready():
	buttons_container.hide()
	
	num = buttons_container.get_child_count()
	for button in buttons_container.get_children():
		button.global_position = global_position + get_rect().size / 2
		button.pressed.connect(_show_talent_tree.bind(button.text))


func _on_pressed():
	disabled = true

	if active:
		_hide_menu()
	else:
		_show_menu()

func _show_menu():
	var spacing = TAU / num
	
	for button in buttons_container.get_children():
		var a = spacing * button.get_index() - PI / 2
		var dest = buttons_container.global_position - button.get_rect().size / 2 + Vector2(radius, 0).rotated(a)
		
		var tween = get_tree().create_tween()
		tween.tween_property(button, "global_position", dest, animatinSpeed).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		tween.parallel()
		tween.tween_property(button, "scale", Vector2.ONE, animatinSpeed).set_trans(Tween.TRANS_LINEAR)
	
	await get_tree().create_timer(animatinSpeed).timeout
	
	disabled = false
	active = true
		
	buttons_container.show()

func _hide_menu():
	for button in buttons_container.get_children():
		var tween = get_tree().create_tween()
		tween.tween_property(button, "global_position", global_position+ get_rect().size / 2, animatinSpeed).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
		tween.parallel()
		tween.tween_property(button, "scale",  Vector2(0.5, 0.5), animatinSpeed).set_trans(Tween.TRANS_LINEAR)
		
	await get_tree().create_timer(animatinSpeed).timeout
	disabled = false
	active = false
	buttons_container.hide()

func _show_talent_tree(talentGroup):
	_hide_menu()
	
	var talentNode
	
	if talentGroup == "PUSH":
		talentNode = load("res://talent_trees/talent_tree/push_talent_tree.tscn").instantiate()
	elif talentGroup == "PULL":
		talentNode = load("res://talent_trees/talent_tree/pull_talent_tree.tscn").instantiate()
	elif talentGroup == "CORE":
		talentNode = load("res://talent_trees/talent_tree/core_talent_tree.tscn").instantiate()
	elif talentGroup == "LEG":
		talentNode = load("res://talent_trees/talent_tree/leg_talent_tree.tscn").instantiate()
	elif talentGroup == "BREAK":
		_setup_break()
		return

	talentNode.talentSelection = true
	talentNode.selected_talent.connect(_set_talent)
	add_child(talentNode)

func _set_talent(talent):
	label.text = talent.get_talent_name()
	talent_updated.emit(talent)

func _setup_break():
	label.text = "Break"
	talent_updated.emit(null)
