extends Control

@onready var push_button: Button = %PushButton
@onready var leg_button: Button = %LegButton
@onready var pull_button: Button = %PullButton
@onready var core_button: Button = %CoreButton


func _ready() -> void:
	push_button.pressed.connect(_open_tree.bind(GlobalData.exercice_type.PUSH))
	leg_button.pressed.connect(_open_tree.bind(GlobalData.exercice_type.LEG))
	pull_button.pressed.connect(_open_tree.bind(GlobalData.exercice_type.PULL))
	core_button.pressed.connect(_open_tree.bind(GlobalData.exercice_type.CORE))

func _open_tree(treeTyp: GlobalData.exercice_type) -> void:
	var selectedTree: String
	
	match treeTyp:
		GlobalData.exercice_type.PUSH: selectedTree = "res://talent_trees/push_talent_tree.tscn"
		GlobalData.exercice_type.LEG: selectedTree = "res://talent_trees/leg_talent_tree.tscn"
		GlobalData.exercice_type.CORE: selectedTree = "res://talent_trees/core_talent_tree.tscn"
		GlobalData.exercice_type.PULL: selectedTree = "res://talent_trees/pull_talent_tree.tscn"
		
	get_tree().change_scene_to_file(selectedTree)
