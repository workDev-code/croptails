class_name ToolState
extends NodeState

func enter() -> void:
	actor.velocity = Vector2.ZERO
	actor.current_state = "tool"
	actor.set_animation("tilling_%s" % actor.facing)


func on_animation_finished() -> void:
	state_machine.change_state("idle")


func physics_update(_delta: float) -> void:
	actor.velocity = Vector2.ZERO
