class_name WalkState
extends NodeState

"""
Walk state behavior.
Only movement animation and movement physics are handled here.
The state machine itself remains responsible for switching states.
"""

func enter() -> void:
	if animated_sprite == null:
		return
	animated_sprite.play(actor.get_animation_name("walk"))


func physics_update(_delta: float) -> void:
	if actor == null:
		return

	var input_vector := Vector2(
		Input.get_action_strength("walk_right") - Input.get_action_strength("walk_left"),
		Input.get_action_strength("walk_down") - Input.get_action_strength("walk_up")
	)

	if input_vector == Vector2.ZERO:
		state_machine.change_state(PlayerConstants.State.IDLE)
		return

	if actor.has_method("update_facing_from_vector"):
		actor.update_facing_from_vector(input_vector)

	var move_speed: float = 90.0
	if actor.has_method("get_movement_input"):
		move_speed = actor.MOVE_SPEED

	actor.velocity = input_vector.normalized() * move_speed
	actor.move_and_slide()

	if animated_sprite != null:
		animated_sprite.play(actor.get_animation_name("walk"))
