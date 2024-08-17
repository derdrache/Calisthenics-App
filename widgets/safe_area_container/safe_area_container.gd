extends MarginContainer

@onready var window : Window = get_window()

func _ready():
	var os = OS.get_name()
	if os == "Android" || os ==  "iOS":
		var safe_area  = DisplayServer.get_display_safe_area()
		var window_size = window.size

		add_theme_constant_override("margin_top",safe_area.position.y)
