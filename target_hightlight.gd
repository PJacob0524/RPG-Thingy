extends Node2D
class_name Highlight

@export var Area_Highlight: Sprite2D
@export var Ally_Highlight: Sprite2D
@export var Enemy_Highlight: Sprite2D

var type = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func highlight():
	match type:
		"empty":
			Area_Highlight.visible = true
		"enemy":
			Enemy_Highlight.visible = true
		"ally":
			Area_Highlight.visible = true

func remove():
	queue_free()
