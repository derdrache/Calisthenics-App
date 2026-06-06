extends Node

const BASE_PATH = "user://"
const GLOBAL_EXERCISE_PATH = "user://global_exercise_data.save"
const SAVE_WORKOUT_PATH = "user://workout_templates/"
const WOKROUT_COLLECTION = "user://workout_collection.tres"
const SAVE_EXERSICE_PATH = "user://exercises_history/"
const WORKOUT_COLLECTION_TEMPLATE = "res://resrouces/workout_resources/workout_collection.tres"

const MAX_EXERCISE_LEVEL = 14
const ABC_LIST = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q"]
const DAY_IN_UNIX_TIME = 86400

const initialBreakTime : int = 180

enum exercice_type {PULL, PUSH, CORE, LEG}
enum workout_modus {NORMAL, SUPERSET}

var exerciseCompleted: Array[int]
var exerciseUnlocked: Array[int]

const PULL_TALENT_TREE = "res://talent_trees/pull_talent_tree.tscn"
const PUSH_TALENT_TREE = "res://talent_trees/push_talent_tree.tscn"
const CORE_TALENT_TREE = "res://talent_trees/core_talent_tree.tscn"
const LEG_TALENT_TREE = "res://talent_trees/leg_talent_tree.tscn"

func _ready() -> void:
	_create_dir()
	
	SaveAndLoad.load_exercise_data()
	
func _create_dir() -> void:
	var dir := DirAccess.open(BASE_PATH)
	dir.make_dir("workout_templates")
	dir.make_dir("exercises_history")
