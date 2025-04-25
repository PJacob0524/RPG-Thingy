extends Node

@export var battle_line: Battle_Line
@export var action_menu:  Action_Menu

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	battle_line.request_button.connect(action_menu.add_button)
	battle_line.remove_action_menu.connect(action_menu.remove_action_menu)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
