extends Control

signal selected(talentResource: TalentResource)

@onready var titleLabel: Label = %titleLabel
@onready var total_reps_label: Label = %totalRepsLabel
@onready var total_sets_label: Label = %totalSetsLabel
@onready var max_rep_label: Label = %maxRepLabel
@onready var best_reuslt_label: Label = %bestReusltLabel
@onready var tabs: HBoxContainer = %tabs
@onready var stats_window: VBoxContainer = %StatsWindow
@onready var info_window: VBoxContainer = %InfoWindow
@onready var info_description_label: Label = %InfoDescriptionLabel
@onready var exercise_video_link: LinkButton = %exerciseVideoLink
@onready var select_button: Button = %SelectButton

@export var talentResource: TalentResource
@export var exerciseHistory: Exercise_History
@export var title: String

var currentTab := 1
var tabWindows: Array[Control] = []
var withTalentSelection := false

func _ready() -> void:
	add_to_group("infoWindow")
	
	tabWindows = [stats_window, info_window]
	
	select_button.visible = withTalentSelection
	
	_set_signals()
	
	_set_labels()
	
	_refresh_tabs()
	_refresh_windows()

func _set_signals() -> void:
	for tab in tabs.get_children():
		tab.selected.connect(_on_tab_selected)

func _set_labels() -> void:
	if talentResource:
		exercise_video_link.uri = talentResource.videoLink
		info_description_label.text = talentResource.description
	
	if exerciseHistory:
		titleLabel.text = title
		total_reps_label.text = str(exerciseHistory.totalReps)
		total_sets_label.text = str(exerciseHistory.totalSets)
		max_rep_label.text = str(exerciseHistory.maxRep)
		best_reuslt_label.text = ", ".join(exerciseHistory.bestResult)

func _on_tab_selected(index: int) -> void:
	currentTab = index
	_refresh_tabs()
	
	_refresh_windows()
	
func _refresh_windows() -> void:
	for i in tabWindows.size():
		var tabWindow: Control = tabWindows[i]
		tabWindow.visible = i == currentTab
		
		
func _input(event: InputEvent) -> void:
	var leftClick := Input.is_action_just_pressed("leftMouseClick")
	
	if not leftClick: 
		return
		
	var onWindow := get_global_rect().has_point(event.position)
	
	if not onWindow:
		queue_free()
	
func _refresh_tabs() -> void:
	for i in tabs.get_child_count():
		var tab :Control = tabs.get_child(i)
		tab.set_select(i == currentTab)
		
func _on_close_button_pressed() -> void:
	queue_free()


func _on_select_button_pressed() -> void:
	selected.emit(talentResource)
