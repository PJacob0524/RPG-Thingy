extends Node2D
class_name Character

@export var actions: Array[Action]
@export var player: bool
@export var health: int
@export var speed: int
var slot = null

func _ready():
	pass # Replace with function body.

func _process(delta):
	pass

func do(action: Action, target: int):
	if action.move_to:
		request_move.emit(slot, target)

signal request_move(from: int, to: int)
