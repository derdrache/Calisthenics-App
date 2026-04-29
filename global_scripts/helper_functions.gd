extends Node
class_name HelperFunctions

static func seconds_in_minutes_string(seconds: int) -> String:
	var pufferMinutes :float = seconds / 60.0
	var minutes := int(pufferMinutes)
	var restSeconds := (pufferMinutes - minutes) * 60
	var spezialZero := "0" if restSeconds < 10 else ""
	
	return str(minutes) + ":" + spezialZero + str(round(restSeconds))

static func is_in_future(date: Dictionary) -> bool:
	var currentDateUnix := Time.get_unix_time_from_system()
	var selectedDateUnix := Time.get_unix_time_from_datetime_dict(date)

	return selectedDateUnix >= currentDateUnix
