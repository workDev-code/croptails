class_name Player
extends CharacterBody2D

const MOVE_SPEED: float = 90.0

var facing: String = "down"
var current_state: String = "Idle"


func get_movement_input() -> Vector2:
	var input_vector := Vector2(
		Input.get_action_strength("walk_right") - Input.get_action_strength("walk_left"),
		Input.get_action_strength("walk_down") - Input.get_action_strength("walk_up")
	)

	if input_vector != Vector2.ZERO:
		update_facing_from_vector(input_vector)

	return input_vector


func update_facing_from_vector(direction: Vector2) -> void:
	if abs(direction.x) > abs(direction.y):
		facing = "right" if direction.x > 0 else "left"
		return

	if direction.y != 0:
		facing = "down" if direction.y > 0 else "up"


func set_animation(animation_name: String) -> void:
	var sprite: AnimatedSprite2D = get_node_or_null("AnimatedSprite2D") as AnimatedSprite2D
	if sprite == null:
		return

	if sprite.animation != animation_name:
		sprite.play(animation_name)
