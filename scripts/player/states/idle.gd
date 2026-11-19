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

	var player := actor as Player
	if player == null:
		return

	var input_vector: Vector2 = player.get_movement_input()

	if input_vector != Vector2.ZERO:
		state_machine.change_state(PlayerConstants.State.WALK)
		return

	if animated_sprite != null:
		animated_sprite.play(actor.get_animation_name("idle"))
