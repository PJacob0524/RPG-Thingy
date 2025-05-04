extends Button
class_name Action_Button

@export var value = null

func _ready():
	pressed.connect(not_cool_godot)

func not_cool_godot():
	action_pressed.emit(value)

signal action_pressed(value)
