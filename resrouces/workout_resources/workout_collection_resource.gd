extends Resource
class_name WorkoutCollectionResource

@export var history: Array[WorkoutResource]
@export var plan: Array[WorkoutResource]

func save() -> void:
	SaveAndLoad.save_resource(GlobalData.BASE_PATH, self, "workout_collection")

func add_workout(workout: WorkoutResource, collectionType: String) -> void:
	if collectionType == "History": history.append(workout)
	elif collectionType == "Plan": plan.append(workout)

	save()

func get_workout(date: Dictionary, collectionType: String = "") -> WorkoutResource:
	var workoutList := history + plan
	
	if collectionType == "History": workoutList = history
	elif collectionType == "Plan": workoutList = history
	
	for workout: WorkoutResource in workoutList:
		var workoutDate := workout.get_date()
		
		var sameDay: bool = workoutDate.day == date.day
		var sameMonth: bool = workoutDate.month == date.month
		var sameYear: bool = workoutDate.year == date.year
		
		if sameDay and sameMonth and sameYear: return workout
		
	return

func delete_plan_workout(date: Dictionary) -> void:
	var index := -1
	
	for i in plan.size():
		var day: int = plan[i].planDate.day
		var month: int = plan[i].planDate.month
		var year: int = plan[i].planDate.year
		
		if day == date.day and month == date.month and year == date.year: 
			index = i
			break
		
	if index >= 0:
		plan.remove_at(index)
		save()	

func delete_unfinished_workout_plans() -> void:
	var deletePlanWorkouts := []
	
	for workoutPlan in plan:
		var currentDate := Time.get_datetime_dict_from_system()
		var planDate := workoutPlan.planDate
		var isPastWorkout : bool = (planDate.day +1 <= currentDate.day 
			or planDate.month +1 <= currentDate.month or planDate.year +1 <= currentDate.year)
		
		if not isPastWorkout: continue
		
		var workout := get_workout(workoutPlan.planDate, "History")
		if not workout: deletePlanWorkouts.append(workoutPlan)

	for workoutPlan: WorkoutResource in deletePlanWorkouts:
		delete_plan_workout(workoutPlan.planDate)
