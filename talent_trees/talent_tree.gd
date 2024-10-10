extends Control
class_name TalentTree

signal selected_talent

@export var talentSelection := false
@export var resetAllTalents := false:
	set(newValue):
		resetAllTalents = false
		_reset_talents()
		
@onready var top_navigation_bar: TopNavigationBar = %TopNavigationBar
@onready var scroll_container: ScrollContainer = %ScrollContainer
@onready var content_container: MarginContainer = %ContentContainer
@onready var skill_container: HBoxContainer = %SkillContainer

func _ready() -> void:
	top_navigation_bar.previousPage.connect(_on_top_navigation_bar_previous_page)
	top_navigation_bar.closePage.connect(_on_top_navigation_bar_close_page)
	
	if talentSelection: _set_talent_selection()
		
func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("quit"): 
		get_tree().quit()

func _process(_delta: float) -> void:
	queue_redraw()
	
func _draw() -> void:
	for talentNode: TalentIcon in get_tree().get_nodes_in_group("talents"):
		if talentNode.talentResource == null: continue

		for resource: TalentResource in talentNode.talentResource.unlocks:
			var targetNode := _get_node_with_resource(resource)
			var sourcePosition: Vector2 = ((talentNode.global_position) 
				+ (talentNode.get_center() * scroll_container.scale.x))
			
			if targetNode == null: 
				push_error(talentNode, " talent not available")
				continue
			
			var targetPosition: Vector2 = (targetNode.global_position) + (targetNode.get_center()* scroll_container.scale.x)
			var color := Color.BLACK if targetNode.talentResource.is_unlocked else Color.GRAY
		
			if targetPosition.y < 200: continue
			
			draw_line(sourcePosition, targetPosition, color, 7.0)

func _get_node_with_resource(resource: TalentResource) -> TalentIcon:
	for talentNode: TalentIcon in get_tree().get_nodes_in_group("talents"):
		if talentNode.talentResource.get_talent_name() == resource.get_talent_name() :
			return talentNode
			
	return

func _reset_talents() -> void:	
	print("reset talent")
	for talentNode: TalentIcon in get_tree().get_nodes_in_group("talents"):
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

func _on_top_navigation_bar_previous_page() -> void:
	var mainMenu: MainMenu = load("res://main_menu_page/main_menu.tscn").instantiate()

	mainMenu.initalPage = 1

	get_tree().current_scene.queue_free()
	get_tree().root.add_child(mainMenu)
	get_tree().current_scene = mainMenu

func _set_talent_selection() -> void:
	var newTitle: String = "SELECT " + top_navigation_bar.title + " WORKOUT"
	top_navigation_bar.change_title(newTitle, 30)
	top_navigation_bar.hide_back_button()
	top_navigation_bar.show_close_button()
	
	for talent: TalentIcon in get_tree().get_nodes_in_group("talents"):
		talent.button.pressed.connect(_get_selected_talent.bind(talent.talentResource))

func _get_selected_talent(talent: TalentResource) -> void:
	selected_talent.emit(talent)
	queue_free()

func _on_top_navigation_bar_close_page() -> void:
	queue_free()
