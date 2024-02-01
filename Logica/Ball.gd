extends Sprite

var STATE = 1

var dirY = 1
var dirX = 1
var vel = 200

onready var Paddle1 = owner.get_node("Paddle1")
onready var Paddle2 = owner.get_node("Paddle2")

onready var Boings = owner.get_node("Boings")

onready var offsetColl = (get_rect().size.x/2) #+ Paddle1.get_rect().size.x/2
onready var collPoint = owner.get_node("collred")
var genTimer = 0.0
onready var blocs = owner.get_node("Blocs")

func _process(delta):
	if STATE == 1: return
	if position.x < 0.0 - get_rect().size.x/2: 
		STATE = 1
		owner.catch_Ball(self)
		return
	
	var mov = Vector2(dirX,dirY).normalized()
	var prevPoint = position
	position = position + mov*delta*vel
	
	#Check paddle collsion, si sobrepasa el punto donde interesa la colision.
	if position.x <= Paddle2.position.x + offsetColl and prevPoint.x > Paddle2.position.x + offsetColl:
		paddle_Collision(Paddle2,prevPoint,Paddle2.position.x + offsetColl)
		pass
	if position.x <= Paddle1.position.x + offsetColl and prevPoint.x > Paddle1.position.x + offsetColl :
		paddle_Collision(Paddle1,prevPoint,Paddle1.position.x + offsetColl)
		pass
	
	#Check collisions for Boings
	for i in Boings.get_children():
		var radDist = (get_rect().size.x/2) + (i.get_rect().size.x/2) 
		var posDist = position.distance_to(i.position)
		if posDist <= radDist and i.get_rect().has_point(position - i.position):
			var angle = position.angle_to_point(i.position)
			dirY = sin(angle) + randf()
			dirX = -dirX
			vel += 10
		pass
	
	#limite de piso y suelo en la misma medida
#	if abs(position.y - get_viewport().size.y/2) > get_viewport().size.y/2 - (get_rect().size.y/2):
#		dirY = dirY*-1
#		position.y = clamp(position.y,(get_rect().size.y/2),get_viewport().size.y - (get_rect().size.y/2))
	
	# Para ambas paredes verticales
#	if abs(position.x - get_viewport().size.x/2) > get_viewport().size.x/2 - (get_rect().size.x/2):
#		dirX = -dirX
#		position.x = clamp(position.x,(get_rect().size.x/2),get_viewport().size.x - (get_rect().size.x/2))
	
	#Limite superior e inferior 
	if position.y < get_rect().size.y/2:
		position.y = get_rect().size.y/2
		dirY = dirY*-1
	if position.y > get_viewport().size.y - (get_rect().size.y/2) - 16:#el 16 para espaci del riel
		position.y = get_viewport().size.y - (get_rect().size.y/2) - 16
		dirY = dirY*-1
	
	#Para la pared derecha
	if position.x > get_viewport().size.x - get_rect().size.x/2:
		position.x = get_viewport().size.x - get_rect().size.x/2
		dirX = -dirX
	
	# Check blocs collision
	var blocArea = get_Area_Bloc_Matrix(blocs.blocWidth,blocs.blocHeight)
	if blocs.Blocs_Matrix[blocArea.x][blocArea.y] != null:
		collPoint.position = position
		blocs.bloc_Hitted(blocArea.x,blocArea.y)
		dirX = -dirX

func paddle_Collision(paddle, _prev_pos: Vector2, _intersect_X: float):
	if dirX > -1: 
		print("no pasa", randi())
		return # si no es menos que cero entonces no corremos todo el >>
	#código es tomar la direccion en la que se va osea solo hacia la izquierda en negativo
	var Y = get_Y_intersec_Dist(position,_prev_pos,_intersect_X)# la formula para tomar el >>
	#valor de y cuando x = _intersect_X
	var difference_Y = Y - paddle.position.y# que tan alejado estan los ejes y de paddle y la ball
	if difference_Y > -paddle.get_rect().size.y/2 and difference_Y < paddle.get_rect().size.y/2:
		# Saber si estamos abajo o arriba del paddel para darle una dirección al colisioner.
		var newDirY = -1 if difference_Y < 0 else 1# saber si la pelota cilisiono en la mitad superior >>
		# o inferiro de paddle 
		dirY += (difference_Y/128) #sumar un poco el calor Y para cambiar el ángulo.
		dirY = abs(dirY)*newDirY #tomar el valor abssoluto de la suma para que no afecte en el cambio >>
		# de signo en la multiplicación
		dirY = clamp(dirY,-1.5,1.5)# hacer un límite del maximo valor de y para que movimiento no sea >>
		# tan vertical
		dirX = -dirX# Cambio de la dierccion horizontal
		vel += 25 # sumar la velocidad al golpear
		position = Vector2(_intersect_X,Y)# regresar al punto de colision 
		#collPoint.position = Vector2(_intersect_X,Y)# test del la colision
		pass
	pass

func get_Y_intersec_Dist(_pos: Vector2,_prev_Pos:Vector2 ,_intersect_X:float) -> float:
	#intersect_X the ditance of the axis x where the collision have to take place.
	var m = (_prev_Pos.y - _pos.y) / (_prev_Pos.x - _pos.x) #Get pendiente (trigonometric formula)
	return m*(_intersect_X - _pos.x) + _pos.y# return the formula to get the "y" in >>
	#Vector2(_intetsect_X,y)

func get_Area_Bloc_Matrix(_wide,_height) -> Vector2:
	var x = int(position.x)
	var mod = int(x)%_wide
	var row = (x - mod)/_wide
	
	var y = int(position.y)
	mod = int(y)%_height
	var colunm = (y - mod)/_height
	return Vector2(row,colunm)

func launch_Force(force):
	if force < 200: force = 200
	STATE = 0
	dirX = -1
	vel = force
	dirY = 0
