extends Node2D

onready var Blocs_Matrix :Array 
onready var blocWidth = 16
onready var blocHeight = 32
 
onready var rows = int(get_viewport().size.x/blocWidth)
onready var colums = int(get_viewport().size.y/blocHeight)

func _ready():
	for x in range(rows):
		Blocs_Matrix.append([])
# warning-ignore:unused_variable
		for y in range(colums):
			Blocs_Matrix[x].append(null)
	
	for i in get_children():
		Blocs_Matrix[i.position.x/blocWidth][i.position.y/blocHeight] = i

func bloc_Hitted(row,col):
	var bloc = Blocs_Matrix[row][col]
	if bloc.frame == 1:
		Blocs_Matrix[row][col] = null
		bloc.frame = 0
	else:
		bloc.frame -= 1
	
