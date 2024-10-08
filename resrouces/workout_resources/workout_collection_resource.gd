extends Resource
class_name workoutCollectionResource

@export var history: Array[WorkoutResource]
@export var plan: Array[WorkoutResource]

func save() -> void:
	SaveAndLoad.save_resource(SaveAndLoad.basePath, self, "workout_collection")

func add_workout(workout: WorkoutResource, collectionType: String) -> void:
	if collectionType == "History": history.append(workout)
	elif collectionType == "Plan": plan.append(workout)

	save()

func get_workout(date: Dictionary, collectionType: String = "") -> WorkoutResource:
	var workoutList = history + plan
	
	if collectionType == "History": workoutList = history
	elif collectionType == "Plan": workoutList = history
	
	for workout: WorkoutResource in workoutList:
		var workoutDate = workout.get_date()
		
		var sameDay = workoutDate.day == date.day
		var sameMonth = workoutDate.month == date.month
		var sameYear = workoutDate.year == date.year
		
		if sameDay and sameMonth and sameYear: return workout
		
	return

func delete_plan_workout(date: Dictionary) -> void:
	var index := -1
	
	for i in plan.size():
		var day = plan[i].planDate.day
		var month = plan[i].planDate.month
		var year = plan[i].planDate.year
		
		if day == date.day and month == date.month and year == date.year: 
			index = i
			break
		
	if index >= 0:
		plan.remove_at(index)
		save()	

func delete_unfinished_workout_plans() -> void:
	var deletePlanWorkouts = []
	
	for workoutPlan in plan:
		var currentDate = Time.get_datetime_dict_from_system()
		var planDate = workoutPlan.planDate
		var isWorkoutPast = planDate.day +1 <= currentDate.day or planDate.month +1 <= currentDate.month or planDate.year +1 <= currentDate.year
		
		if not isWorkoutPast: continue
		
		var workout = get_workout(workoutPlan.planDate, "History")
		if workout.is_empty(): deletePlanWorkouts.append(workoutPlan)

	for workoutPlan in deletePlanWorkouts:
		delete_plan_workout(workoutPlan.date)
