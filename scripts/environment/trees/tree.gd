class_name BaseTree
extends StaticBody2D

@export var max_health: int = 3
@export var tree_name: StringName = "tree"

var health: int


func _ready() -> void:
	health = max_health
	print("[TREE] %s ready with health %d" % [tree_name, health])


func take_damage(amount: int) -> void:
	if amount <= 0:
		return

	health = maxi(health - amount, 0)
	print("[TREE] %s health: %d/%d" % [tree_name, health, max_health])

	if health == 0:
		break_tree()


func break_tree() -> void:
	print("[TREE] %s destroyed" % tree_name)
	queue_free()
