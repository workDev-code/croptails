class_name ToolState
extends NodeState

"""
Tool state behavior.
This state only plays the tool animation and then asks the machine to return
back to the proper idle state when the animation completes.
"""

func enter() -> void:
	if actor == null:
		return
	actor.velocity = Vector2.ZERO
	if animated_sprite != null:
		animated_sprite.play(actor.get_animation_name("tilling"))


func on_animation_finished() -> void:
	if state_machine == null:
		return
	state_machine.change_state(PlayerConstants.State.IDLE)


func physics_update(_delta: float) -> void:
	if actor == null:
		return
	actor.velocity = Vector2.ZERO
