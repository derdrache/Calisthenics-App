@tool
extends Control

signal selected_talent

@export var talentSelection := false
@export var resetAllTalents = false:
	set(newValue):
		resetAllTalents = false
		_reset_talents()
		
@onready var top_navigation_bar = %TopNavigationBar

const MAIN_MENU = preload("res://main_menu_page/main_menu.tscn")		

var changedScale = 1

func _ready():
	top_navigation_bar.previousPage.connect(_on_top_navigation_bar_previous_page)
	top_navigation_bar.closePage.connect(_on_top_navigation_bar_close_page)
	
	changedScale = %ScrollContainer.scale.x
	if talentSelection: 
		_set_talent_selection()

func _input(event):
	if Input.is_action_just_pressed("quit"): 
		get_tree().quit()
		
	if event is InputEventMouseButton and event.button_index == 4 and event.is_pressed():
		changedScale += 0.1
		_zoom()
	elif event is InputEventMouseButton and event.button_index == 5 and event.is_pressed():
		changedScale -= 0.1
		_zoom()

func _zoom():
	changedScale = clamp(changedScale, 0.5, 2)
	var zoomPosition = get_global_mouse_position() * changedScale - get_global_mouse_position()
	%ScrollContainer.scale = Vector2(changedScale, changedScale)
	%ScrollContainer.size = size / %ScrollContainer.scale 
	
	%ScrollContainer.get_h_scroll_bar().value = abs(zoomPosition.x)
	%ScrollContainer.get_v_scroll_bar().value = abs(zoomPosition.y)
	
func _process(delta):
	queue_redraw()
	
func _draw():
	for talentNode in get_tree().get_nodes_in_group("talents"):
		if talentNode.talentResource ==null: continue

		for resource in talentNode.talentResource.unlocks:
			var targetNode = _get_node_with_resource(resource)
			var sourcePosition = (talentNode.global_position) + (talentNode.get_center() * %ScrollContainer.scale.x)
			
			if targetNode == null: 
				push_error(talentNode, " talent not available")
				continue
			
			var targetPosition = (targetNode.global_position) + (targetNode.get_center()* %ScrollContainer.scale.x)
			var color = Color.BLACK if talentNode.talentResource.is_unlocked else Color.GRAY
			
			draw_line(sourcePosition, targetPosition, color, 7.0)

func _set_scrollbar_center(scrollBar):
	var center = (scrollBar.max_value - scrollBar.page) / 2
	scrollBar.value = center

func _get_node_with_resource(resource):
	for talentNode in get_tree().get_nodes_in_group("talents"):
		if talentNode.talentResource == resource:
			return talentNode

func _reset_talents():	
	print("reset talent")
	for talentNode in get_tree().get_nodes_in_group("talents"):
		talentNode.talentResource = null
	#
	#var talentIconNode = preload("res://talent_tree/talent_icon.tscn").instantiate()
	#var defaultStyleBox = talentIconNode.get_theme_stylebox("panel")
	#
	#for level in %SkillContainer.get_children():
		#if not "Level" in level.name: continue
		#
		#for child in level.get_children():
			#child.talentResource = null
			#child.add_theme_stylebox_override("panel", defaultStyleBox)

func _on_top_navigation_bar_previous_page():
	var mainMenu = MAIN_MENU.instantiate()
	
	mainMenu.initalPage = 1

	get_tree().current_scene.queue_free()
	get_tree().root.add_child(mainMenu)
	get_tree().current_scene = mainMenu

func _set_talent_selection():
	var newTitle = "SELECT " + top_navigation_bar.title + " WORKOUT"
	top_navigation_bar.change_title(newTitle, 45)
	top_navigation_bar.hide_back_button()
	top_navigation_bar.show_close_button()
	
	for talent in get_tree().get_nodes_in_group("talents"):
		talent.button.pressed.connect(_get_selected_talent.bind(talent.talentResource))

func _get_selected_talent(talent):
	selected_talent.emit(talent)
	queue_free()

func _on_top_navigation_bar_close_page():
	queue_free()
