extends Node2D
class_name Battle_Line

@export var slot_count: int
@export var marker: Marker2D
@onready var slots: Array
@onready var selected
@onready var slot_size
@onready var turn_order: Array
var active: Character = null
var highlight_slots: Array
@export var highlight: Highlight
var selected_action = null
var target_options: Array
var current_menu = null
var selected_die_index = null



# Called when the node enters the scene tree for the first time.
func turn_order_sort(a: Character, b: Character):
	return a.speed > b.speed

func _ready():
	slots.resize(slot_count)
	slots.fill(null)
	selected = null
	slot_size = %Shape.shape.size.x / slot_count
	
	for child in get_children():
		if child is Character:
			var index = get_slot(child.position)
			child.slot = index
			slots[index] = child
			turn_order.push_back(child)
			child.request_move.connect(move_slots)
	
	turn_order.sort_custom(turn_order_sort)
	
	next_turn()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if selected != null:
		marker.visible = true
		marker.position.x = slot_size * selected + slot_size / 2 - %Shape.shape.size.x / 2
	else:
		marker.visible = false
	
	if not active.action_dice.size():
		next_turn()
	
	for i in range(0, slot_count):
		if slots[i]:
			slots[i].slot = i
			slots[i].position.x = slot_size * i + slot_size / 2 - %Shape.shape.size.x / 2
			slots[i].position.y = 0

func get_slot(position: Vector2):
	return (position.x + %Shape.shape.size.x / 2) / slot_size as int

func get_slot_pos(index: int):
	return index * slot_size - %Shape.shape.size.x / 2 + slot_size / 2

func next_turn():
	print("Next turn!")
	
	active = turn_order.pop_front()
	
	print(active.name)
	
	active.start_turn()
	print 
	
	if active.player:
		pass
	else:
		pass
	
	turn_order.push_back(active)

func get_targets(character: Character, action: Action):
	var result: Array
	for i in range(-action.range, action.range + 1):
		var index = character.slot + i
		if(index >= 0 && index < slot_count):
			if(slots[index] is Character):
				if(slots[index] == character && action.allowed_targets["self"]):
					result.push_back(index)
				elif(slots[index].player == character.player && action.allowed_targets["allies"]):
					result.push_back(index)
				elif(slots[index].player != character.player && action.allowed_targets["enemies"]):
					result.push_back(index)
			elif(action.allowed_targets["empty"]):
				result.push_back(index)
	return result

func highlight_slot(index: int):
	var slot_highlighter = highlight.duplicate()
	slot_highlighter.position.x = get_slot_pos(index)
	if(slots[index] is Character):
		if(slots[index].player):
			slot_highlighter.type = "ally"
		else:
			slot_highlighter.type = "enemy"
	else:
		slot_highlighter.type = "empty"
	slot_highlighter.highlight()
	add_child(slot_highlighter)
	highlight_slots.push_back(slot_highlighter)

func highlight_target_options():
	for target in target_options:
		highlight_slot(target)

func clear_highlights():
	for highlighter in highlight_slots:
		highlighter.remove()
	highlight_slots.clear()

func _on_battle_area_input_event(viewport, event: InputEvent, shape_idx):
	if(event is InputEventMouseButton and event.pressed):
		var click = event.position - self.position + %Shape.shape.size / 2
		selected = click.x / slot_size as int

		match current_menu:
			null:
				if slots[selected] == active && active.player:
					menu("action")
			"target":
				if target_options.has(selected):
					action_selected(selected)
				else:
					menu("clear")

func move_slots(from: int, to: int):
	var temp = slots[from]
	slots[from] = slots[to]
	slots[to] = temp

func action_selected(value):
	match current_menu:
		"action":
			selected_action = value
			menu("dice")
		"target":
			active.do(selected_action, value, slots[value], selected_die_index)
			menu("clear")
		"dice":
			selected_die_index = value
			selected_action = get_upcast_action(selected_action, value)
			menu("target")
	
func menu(type: String):
	remove_action_menu.emit()
	clear_highlights()
	current_menu = type
	match type:
		"action":
			for action in active.actions:
				for dice in active.action_dice:
					if dice >= action.cost:
						request_button.emit(action.name, action)
						break
		"dice":
			for i in range(0,active.action_dice.size()):
				if active.action_dice[i] >= selected_action.cost:
					request_button.emit(str(active.action_dice[i]), i)
		"target":
			target_options = get_targets(active, selected_action)
			highlight_target_options()
		"clear":
			selected_action = null
			target_options.clear()
			clear_highlights()
			remove_action_menu.emit()
			selected = null
			current_menu = null

func get_upcast_action(action, dice):
	return active.get_upcast(action, dice)

signal request_button(name: String, value)
signal remove_action_menu()
