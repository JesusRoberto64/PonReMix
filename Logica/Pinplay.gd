extends Node2D

var paddle_1 
var paddle_2

var accel = 50 #50
var desaccel = 75#25
var direction = 1
var y = 0.0

onready var hammer = $LauncherHammer/Hammer
enum HAMMER {IDLE,CHARGE,RELACE}
var HState = HAMMER.IDLE
var charge = 0.0

onready var launcher = $LauncherHammer/Launcher
var luncherMov = 0.0 

var balls = []
enum BALLS {SET, LAUNCH, HIT, IDLE, PREPARE}
var BState = BALLS.IDLE
var curSetBall = null

func _ready():
	for i in $Balls.get_children():
		balls.append(i)
#		var dist_Ham = hammer.get_rect().size.x - i.get_rect().size.x/2
#		i.position.x = dist_Ham + ((i.get_rect().size.x)*balls.size())
		retreat_Balls()
		i.position.y = hammer.position.y + 8.0
	

func _process(delta):
	#Para saber si se esta precionando el botón
	var isMov = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	#En qué dirección está apuntado 
	if Input.is_action_pressed("ui_down"):
		direction = 1
	elif Input.is_action_pressed("ui_up"):
		direction = -1
#	# La aceleracion y desaleracion gráfica
	if !isMov == 0:
		y += accel
		y = clamp(y,0,800) # Poner un límite de sustain o meseta 
	elif isMov == 0:
		y -= desaccel
		y = clamp(y,0,400) # Poner otro límite de desaleración
	
#	#Método básico de movimient
#	if isMov == 0:
#		direction = 0
#	y = 350
	
	$Paddle1.position.y += y*direction*delta # movimiento correjirlo con Delta
	# poner limites superior e inferior
	$Paddle1.position.y = clamp($Paddle1.position.y,$Paddle1.get_rect().size.y/4,(get_viewport().size.y-$Paddle1.get_rect().size.y/4) -16)
	$Paddle2.position.y = $Paddle1.position.y # copia la posicion de otro
	
	# Hammer Logic 
	if Input.is_action_pressed("ui_left"):
		HState = HAMMER.CHARGE
		hammer.position.x -= delta*100
		hammer.position.x = max(-30,hammer.position.x)
		charge += 25
		charge = min(510,charge)
		retreat_Balls()
	elif Input.is_action_just_released("ui_left"):
		HState = HAMMER.RELACE
	
	match HState:
		HAMMER.RELACE:
			hammer.position.x += delta*charge
			hammer.position.x = min(0,hammer.position.x)
			retreat_Balls()
			if hammer.position.x == 0:
				BState = BALLS.LAUNCH
				HState = HAMMER.IDLE
			
	
	match BState:
		BALLS.PREPARE:
			#var dist_Ham = hammer.get_rect().size.x - curSetBall.get_rect().size.x/2
			#curSetBall.position.x = dist_Ham + ((curSetBall.get_rect().size.x)*balls.size())
			retreat_Balls()
			curSetBall.position.y = hammer.position.y + 8.0
			BState = BALLS.IDLE
			pass
		BALLS.LAUNCH:
			if balls.size()< 1: 
				BState = BALLS.IDLE
				charge = 0
				return
			var launchBall = balls[balls.size()-1]
			launchBall.position = launcher.position + Vector2(-launchBall.get_rect().size.x/2,launcher.get_rect().size.y/2)
			var f = charge
			launchBall.launch_Force(f)
			 
			balls.remove(balls.size()-1)
			BState = BALLS.IDLE
			charge = 0
			pass
	
	#Launcher Logic
	luncherMov += delta
	launcher.position.y = (cos(luncherMov)*100) + (get_viewport().size.y/2)
	launcher.position.y = clamp(launcher.position.y,launcher.get_rect().size.y/2,(get_viewport().size.y-launcher.get_rect().size.y/4) -16)
	

func catch_Ball(ball):
	balls.append(ball)
	curSetBall = ball
	BState = BALLS.PREPARE
	pass

func retreat_Balls():
	if balls.size() > 0:
			var ballSize = balls[0].get_rect().size.x
			for i in range(balls.size()):
				var dist = hammer.get_child(0).global_position.x + ballSize/2
				balls[i].position.x = dist + (i*ballSize)
