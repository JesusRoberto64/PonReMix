extends Node

func _input(event):
	if event.is_action_pressed("ui_accept"):
		if get_tree().paused == true:
			get_tree().paused = false
		else:
			get_tree().paused = true
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
