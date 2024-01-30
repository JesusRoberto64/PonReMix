extends CanvasLayer

func _process(_delta):
	$numb.text = "FPS " + String(Engine.get_frames_per_second())

