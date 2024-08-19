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
var touchEvents = {}
var last_drag_distance = 0
var zoom_sensitivity = 10
var defaultContentSize 

func _ready():
	top_navigation_bar.previousPage.connect(_on_top_navigation_bar_previous_page)
	top_navigation_bar.closePage.connect(_on_top_navigation_bar_close_page)
	
	defaultContentSize = %ContentContainer.size

	changedScale = %ScrollContainer.scale.x
	if talentSelection: 
		_set_talent_selection()

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("quit"): 
		get_tree().quit()
	
	var zoom = false
		
	if event is InputEventMouseButton and event.button_index == 4 and event.is_pressed():
		changedScale += 0.1
		zoom = true
	elif event is InputEventMouseButton and event.button_index == 5 and event.is_pressed():
		changedScale -= 0.1
		zoom = true
	
	
	if event is InputEventScreenTouch:
		if event.pressed:
			touchEvents[event.index] = event
		else:
			touchEvents.erase(event.index)
	elif event is InputEventScreenDrag:
		touchEvents[event.index] = event
		
		if touchEvents.size() == 2:
			var drag_distance = touchEvents[0].position.distance_to(touchEvents[1].position)
			
			if drag_distance - last_drag_distance > 0:
				changedScale += 0.01
				last_drag_distance = drag_distance
				zoom = true
			elif drag_distance - last_drag_distance < 0:
				changedScale -= 0.01
				last_drag_distance = drag_distance
				zoom = true
				
			
	if zoom: _zoom()
	


func _zoom():
	changedScale = clamp(changedScale, 1, 2)
	
	var zoomPosition = get_global_mouse_position() * changedScale - get_global_mouse_position()
	%ScrollContainer.scale = Vector2(changedScale, changedScale)
	
	var zoomFactor = Vector2.ONE + (Vector2(0.05, 0.3) * %ScrollContainer.scale)
	%SkillContainer.custom_minimum_size = defaultContentSize *  zoomFactor

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
			
			if targetPosition.y < 200: continue
			
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
	top_navigation_bar.change_title(newTitle, 30)
	top_navigation_bar.hide_back_button()
	top_navigation_bar.show_close_button()
	
	for talent in get_tree().get_nodes_in_group("talents"):
		talent.button.pressed.connect(_get_selected_talent.bind(talent.talentResource))

func _get_selected_talent(talent):
	selected_talent.emit(talent)
	queue_free()

func _on_top_navigation_bar_close_page():
	queue_free()
