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

	var player := actor as Player
	if player == null:
		return

	var input_vector: Vector2 = player.get_movement_input()

	if input_vector == Vector2.ZERO:
		state_machine.change_state(PlayerConstants.State.IDLE)
		return

	var move_speed: float = player.MOVE_SPEED
	actor.velocity = input_vector.normalized() * move_speed
	actor.move_and_slide()

	if animated_sprite != null:
		animated_sprite.play(actor.get_animation_name("walk"))
