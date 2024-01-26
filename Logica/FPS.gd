extends CanvasLayer

func _process(_delta):
	$numb.text = "FPS " + String(Engine.get_frames_per_second())

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
