class_name NodeState
extends Node

"""
Base class for all player states.

This script defines the common contract used by the state machine:
- a reference to the player actor
- a reference to the owning state machine
- a reference to the character's animated sprite
- lifecycle hooks that child states can override
"""

var state_machine: NodeStateMachine
var actor: CharacterBody2D
var animated_sprite: AnimatedSprite2D


func setup(player: CharacterBody2D, machine: NodeStateMachine, sprite: AnimatedSprite2D) -> void:
	actor = player
	state_machine = machine
	animated_sprite = sprite


func enter() -> void:
	# Child states override this when they need setup work on activation.
	pass


func physics_update(_delta: float) -> void:
	# Child states override this to perform movement or state transitions.
	pass


func exit() -> void:
	# Child states override this for cleanup before leaving the state.
	pass


func on_animation_finished() -> void:
	# Child states override this when they react to animation completion.
	pass
