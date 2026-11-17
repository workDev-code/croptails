class_name IdleState
extends NodeState

"""
Idle state behavior.
Only the idle animation and the transition to Walk are handled here.
The state machine manages lifecycle and state transition execution.
"""

func enter() -> void:
	if animated_sprite == null:
		return
	animated_sprite.play(actor.get_animation_name("idle"))


func physics_update(_delta: float) -> void:
	if actor == null:
		return

	var input_vector := Vector2(
		Input.get_action_strength("walk_right") - Input.get_action_strength("walk_left"),
		Input.get_action_strength("walk_down") - Input.get_action_strength("walk_up")
	)

	if input_vector != Vector2.ZERO:
		state_machine.change_state(PlayerConstants.State.WALK)
		return

	if animated_sprite != null:
		animated_sprite.play(actor.get_animation_name("idle"))
