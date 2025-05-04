extends Node2D
class_name Character

@export var char_name: String
@export var actions: Array[Action]
@export var player: bool
@export var health: int
@export var speed: int
@export var action_dice_pool: Array[int]
var action_dice: Array
var slot = null

func _ready():
	pass # Replace with function body.

func _process(delta):
	pass

func roll_action_dice():
	for die in action_dice_pool:
		action_dice.push_back(randi_range(1,die))

func do(action: Action, index: int, target, dice: int):
	var power = action_dice.pop_at(dice)
	
	%Animator.play("punch")
	
	var max_upcast = null
	for upcast in action.upcast:
		if dice >= upcast:
			if max_upcast == null:
				max_upcast = upcast
			elif max_upcast < upcast:
				max_upcast = upcast
	if max_upcast != null:
		do(action.upcast[max_upcast], index, target, dice)
		return
	
	if action.move_to:
		request_move.emit(slot, index)
	if target && action.damage:
		target.take_damage(action.damage)
	if target && action.heal:
		target.heal(action.heal)
	
	await %Animator.animation_finished
	char_finished_action.emit()

func get_dice_list():
	return action_dice

func take_damage(amount):
	health -= amount

func heal(amount):
	health += amount

func start_turn():
	roll_action_dice()

func end_turn():
	action_dice.clear()

func get_upcast(action, dice):
	var power = action_dice[dice]
	var max_upcast = null
	for upcast in action.upcast:
		if power >= upcast:
			if max_upcast == null:
				max_upcast = upcast
			elif max_upcast < upcast:
				max_upcast = upcast
	if max_upcast != null:
		return action.upcast[max_upcast]
	else:
		return action

signal request_move(from: int, to: int)
signal char_finished_action()
