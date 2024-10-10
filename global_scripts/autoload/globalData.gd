extends Node

const saveExerciseDataPath = "user://exercises/"

const abcList = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q"]
const DAY_IN_UNIX_TIME = 86400

const initialBreakTime : int = 180

enum exercice_type {PULL, PUSH, CORE, LEG}
enum workout_modus {NORMAL, SUPERSET}

func seconds_in_minutes_string(seconds: int) -> String:
	var pufferMinutes :float = seconds / 60.0
	var minutes := int(pufferMinutes)
	var restSeconds := (pufferMinutes - minutes) * 60
	var spezialZero := "0" if restSeconds < 10 else ""
	
	return str(minutes) + ":" + spezialZero + str(round(restSeconds))
