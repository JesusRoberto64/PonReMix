extends Node2D

onready var Blocs_Matrix :Array 
onready var blocW = 16
onready var blocH = 32

func _ready():
	for x in range(get_viewport().size.x/blocW):
		Blocs_Matrix.append([])
# warning-ignore:unused_variable
		for y in range(get_viewport().size.y/blocH):
			Blocs_Matrix[x].append(null)
	
	for i in get_children():
		Blocs_Matrix[i.position.x/blocW][i.position.y/blocH] = i
