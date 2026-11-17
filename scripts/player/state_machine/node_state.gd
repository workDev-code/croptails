class_name NodeState
extends Node

var state_machine: NodeStateMachine = null
var actor: CharacterBody2D = null
var animated_sprite: AnimatedSprite2D = null


func setup(player: CharacterBody2D, machine: NodeStateMachine, sprite: AnimatedSprite2D) -> void:
	actor = player
	state_machine = machine
	animated_sprite = sprite


func enter() -> void:
	pass


func exit() -> void:
	pass


func update(_delta: float) -> void:
	pass


func physics_update(_delta: float) -> void:
	pass


func handle_input(_event: InputEvent) -> void:
	pass


func on_animation_finished() -> void:
	pass
