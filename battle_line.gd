extends Node2D

@export var slot_count: int
@export var marker: Marker2D
@onready var slots: Array
@onready var selected
@onready var slot_size

# Called when the node enters the scene tree for the first time.
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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if selected != null:
		marker.visible = true
		marker.position.x = slot_size * selected + slot_size / 2 - %Shape.shape.size.x / 2
	else:
		marker.visible = false
	
	for i in range(0, slot_count):
		if slots[i]:
			slots[i].slot = i
			slots[i].position.x = slot_size * i + slot_size / 2 - %Shape.shape.size.x / 2
			slots[i].position.y = 0

func get_slot(position: Vector2):
	return (position.x + %Shape.shape.size.x / 2) / slot_size as int

func _on_battle_area_input_event(viewport, event: InputEvent, shape_idx):
	if(event is InputEventMouseButton and event.pressed):
		var click = event.position - self.position + %Shape.shape.size / 2
		var index = click.x / slot_size as int
		
		if selected != null && abs(selected - index) <= slots[selected].range:
			var temp = slots[selected]
			slots[selected] = slots[index]
			slots[index] = temp
			selected = null
		else:
			selected = index
