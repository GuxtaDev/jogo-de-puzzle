class_name Interactable
extends Area2D

@export var prompt: String = "Interact"

signal triggered(interactable: Interactable)


func _ready() -> void:
	add_to_group("interactable")
	collision_layer = 4
	collision_mask = 0


func interact() -> void:
	triggered.emit(self)
