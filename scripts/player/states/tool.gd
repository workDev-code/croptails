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
		var player := actor as Player
		if player == null:
			return
		var tool_key: String = player.get_selected_tool_key()
		var animation_name: String = player.get_animation_name(tool_key)
		animated_sprite.play(animation_name)
		print("[ANIMATION] Playing: %s" % animation_name)


func on_animation_finished() -> void:
	if animated_sprite == null:
		return
	print("[ANIMATION] Finished: %s" % animated_sprite.animation)
	if state_machine != null:
		state_machine.change_state(PlayerConstants.State.IDLE)


func physics_update(_delta: float) -> void:
	if actor == null:
		return
	actor.velocity = Vector2.ZERO
