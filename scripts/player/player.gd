class_name Player
extends CharacterBody2D

const MOVE_SPEED: float = 90.0

var facing: PlayerConstants.Facing = PlayerConstants.Facing.FRONT
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
		facing = PlayerConstants.Facing.RIGHT if direction.x > 0 else PlayerConstants.Facing.LEFT
		return

	if direction.y != 0:
		facing = PlayerConstants.Facing.FRONT if direction.y > 0 else PlayerConstants.Facing.BACK


func direction_name() -> String:
	return PlayerConstants.facing_to_name(facing)


func get_animation_name(prefix: String) -> String:
	return "%s_%s" % [prefix, direction_name()]


func set_animation(animation_name: String) -> void:
	var sprite: AnimatedSprite2D = get_node_or_null("AnimatedSprite2D") as AnimatedSprite2D
	if sprite == null:
		return

	if sprite.animation != animation_name:
		sprite.play(animation_name)
