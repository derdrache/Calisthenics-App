extends Node

const abcList = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q"]

var workoutModus : Array[String] = ["NORMAL", "SUPERSET"]
var initialBreakTime : int = 180


func seconds_in_minutes_string(seconds):
	var pufferMinutes = seconds / 60.0
	var minutes = int(pufferMinutes)
	var restSeconds = (pufferMinutes - minutes) * 60
	var spezialZero = "0" if restSeconds < 10 else ""
	
	return str(minutes) + ":" + spezialZero + str(round(restSeconds))
