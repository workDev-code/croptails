class_name IdleState
extends NodeState

func enter() -> void:
	actor.set_animation("idle_%s" % actor.facing)
	actor.current_state = "idle"


func physics_update(_delta: float) -> void:
	var input_vector: Vector2 = actor.get_movement_input()
	if input_vector != Vector2.ZERO:
		state_machine.change_state("walk")
		return

	if Input.is_action_just_pressed("use_tool"):
		state_machine.change_state("tool")
		return

	actor.set_animation("idle_%s" % actor.facing)
