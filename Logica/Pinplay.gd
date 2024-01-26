extends Node2D

var paddle_1
var paddle_2

var accel = 50 #50
var desaccel = 25#25
var direction = 1
var y = 0.0

func _process(delta):
	#Para saber si se esta precionando el botón
	var isMov = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	#En qué dirección está apuntado 
	if Input.is_action_pressed("ui_down"):
		direction = 1
	elif Input.is_action_pressed("ui_up"):
		direction = -1
	# La aceleracion y desaleracion
	if !isMov == 0:
		y += pow(accel,2.0)*delta # poner un exponente de 2.0
		y = clamp(y,0,800) # Poner un límite de sustain o meseta.
	elif isMov == 0:
		y -= pow(desaccel,3.0)*delta # poner exponente de 3.0
		y = clamp(y,0,400) # Poner otro límite de desaleración
	
	$Paddle1.position.y += y*direction*delta # movimiento
	# poner limites superior e inferior
	$Paddle1.position.y = clamp($Paddle1.position.y,$Paddle1.get_rect().size.y/4,get_viewport().size.y-$Paddle1.get_rect().size.y/4)
	$Paddle2.position.y = $Paddle1.position.y # copia la posicion de otro
	
