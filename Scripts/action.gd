extends Resource
class_name Action

@export var name: String
@export var description: String
@export var allowed_targets: Dictionary = {"self": false, "allies":false, "enemies":false, "empty":false}
@export var move_to: bool
@export var range: int
@export var aoe: bool
@export var effect: Array[Effect]
@export var do_next: Action
@export var damage: int
@export var heal: int
@export var cost: int
@export var upcast: Dictionary = {}
