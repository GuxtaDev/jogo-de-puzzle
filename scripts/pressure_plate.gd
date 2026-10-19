class_name PressurePlate
extends Area2D

signal pressed(plate: PressurePlate)

@export var hint_title: String = "Dica"
@export_multiline var hint_body: String = ""

@onready var sprite: Sprite2D = $Sprite2D

var _occupied: bool = false


func _ready() -> void:
	add_to_group("pressure_plate")
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)


func _on_body_entered(body: Node2D) -> void:
	if _occupied or not body is Player:
		return
	_occupied = true
	_sink(true)
	pressed.emit(self)


func _on_body_exited(body: Node2D) -> void:
	if not body is Player:
		return
	_occupied = false
	_sink(false)


func _sink(down: bool) -> void:
	sprite.modulate = Color(1.7, 1.7, 1.7) if down else Color(1.0, 1.0, 1.0)
	var tween: Tween = create_tween()
	var target: Vector2 = Vector2(0.0, 1.0) if down else Vector2.ZERO
	tween.tween_property(sprite, "position", target, 0.12)