extends Node

const BASE_PATH = "user://"
const SAVE_WORKOUT_PATH = "user://workout_templates/"
const WOKROUT_COLLECTION = "user://workout_collection.tres"
const SAVE_EXERSICE_PATH = "user://exercises/"
const WORKOUT_COLLECTION_TEMPLATE = "res://resrouces/workout_resources/workout_collection.tres"

const ABC_LIST = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q"]
const DAY_IN_UNIX_TIME = 86400

const initialBreakTime : int = 180

enum exercice_type {PULL, PUSH, CORE, LEG}
enum workout_modus {NORMAL, SUPERSET}

func _ready() -> void:
	_create_dir()
	_detet_workout_plans()

func _detet_workout_plans():
	var workoutCollection := SaveAndLoad.load_workout_collection()
	workoutCollection.delete_unfinished_workout_plans()	

static func _create_dir() -> void:
	var dir := DirAccess.open(BASE_PATH)
	dir.make_dir("workout_templates")
	dir.make_dir("exercises")

static func seconds_in_minutes_string(seconds: int) -> String:
	var pufferMinutes :float = seconds / 60.0
	var minutes := int(pufferMinutes)
	var restSeconds := (pufferMinutes - minutes) * 60
	var spezialZero := "0" if restSeconds < 10 else ""
	
	return str(minutes) + ":" + spezialZero + str(round(restSeconds))
