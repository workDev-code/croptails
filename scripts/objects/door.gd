class_name Door
extends StaticBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var door_collision: CollisionShape2D = $CollisionShape2D
@onready var interactable: Interactable = $InteractableComponent

var is_open: bool = false


func _ready() -> void:
	interactable.interacted.connect(_on_interacted)


func _on_interacted(_player: Node2D) -> void:
	if is_open:
		close_door()
	else:
		open_door()


func open_door() -> void:
	if is_open:
		return

	is_open = true
	door_collision.disabled = true
	animated_sprite.play("open_door")
	await animated_sprite.animation_finished
	print("[DOOR] Open")


func close_door() -> void:
	if not is_open:
		return

	is_open = false
	animated_sprite.play("close_door")
	await animated_sprite.animation_finished
	door_collision.disabled = false
	print("[DOOR] Closed")
