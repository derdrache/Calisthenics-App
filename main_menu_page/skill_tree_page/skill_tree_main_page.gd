extends Control

func _ready():
	%PushButton.pressed.connect(_open_tree.bind("push"))
	%LegButton.pressed.connect(_open_tree.bind("leg"))
	%PullButton.pressed.connect(_open_tree.bind("pull"))
	%CoreButton.pressed.connect(_open_tree.bind("core"))

func _open_tree(selection):
	var selectedTree
	
	match selection:
		"push": selectedTree = "res://talent_trees/push_talent_tree.tscn"
		"leg": selectedTree = "res://talent_trees/leg_talent_tree.tscn"
		"core": selectedTree = "res://talent_trees/core_talent_tree.tscn"
		"pull": selectedTree = "res://talent_trees/pull_talent_tree.tscn"
		
	get_tree().change_scene_to_file(selectedTree)
