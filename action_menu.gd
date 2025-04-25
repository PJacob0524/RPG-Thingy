extends CanvasLayer
class_name Action_Menu

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func add_button(name: String, value):
	self.visible = true
	var button: Action_Button = %ActionButton.duplicate()
	button.value = value
	button.visible = true
	button.text = name
	%ActionOptions.add_child(button)
	button.pressed.connect(button.not_cool_godot)

func remove_action_menu():
	for button in %ActionOptions.get_children():
		button.queue_free()
	self.visible = false
