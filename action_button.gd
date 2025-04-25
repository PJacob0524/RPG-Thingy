extends Button
class_name Action_Button

@export var value = null

func not_cool_godot():
	print("test")
	action_pressed.emit(value)

signal action_pressed(value)
