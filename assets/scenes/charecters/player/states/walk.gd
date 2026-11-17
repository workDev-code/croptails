class_name WalkState
extends NodeState

func enter() -> void:
	actor.current_state = "walk"
	actor.set_animation("walk_%s" % actor.facing)


func physics_update(_delta: float) -> void:
	var input_vector: Vector2 = actor.get_movement_input()
	if input_vector == Vector2.ZERO:
		state_machine.change_state("idle")
		return

	if Input.is_action_just_pressed("use_tool"):
		state_machine.change_state("tool")
		return

	actor.update_facing_from_vector(input_vector)
	actor.velocity = input_vector.normalized() * actor.MOVE_SPEED
	actor.move_and_slide()
	actor.set_animation("walk_%s" % actor.facing)
