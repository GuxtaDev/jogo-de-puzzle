class_name Player
extends CharacterBody2D

signal interactable_changed(interactable: Interactable)
signal interacted(interactable: Interactable)

@export var move_speed: float = 120.0
@export var acceleration: float = 900.0
@export var deceleration: float = 1200.0

var can_move: bool = true

var _current: Interactable = null
var _time: float = 0.0
var _visual_home: Vector2 = Vector2.ZERO
var _glow_home: Vector2 = Vector2.ZERO

@onready var visual: Sprite2D = $Visual
@onready var glow: Sprite2D = $Glow
@onready var lamp: PointLight2D = $Lamp
@onready var reach: Area2D = $InteractRange


func _ready() -> void:
	add_to_group("player")
	_visual_home = visual.position
	_glow_home = glow.position
	reach.area_entered.connect(_on_reach_changed)
	reach.area_exited.connect(_on_reach_changed)


func _process(delta: float) -> void:
	_time += delta
	var bob: float = sin(_time * 2.4) * 1.0
	visual.position = _visual_home + Vector2(0.0, bob)
	glow.position = _glow_home + Vector2(0.0, bob)
	lamp.energy = 1.0 + sin(_time * 1.7) * 0.10


func _physics_process(delta: float) -> void:
	var direction: Vector2 = Vector2.ZERO
	if can_move:
		direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var target: Vector2 = direction * move_speed
	var rate: float = acceleration if direction != Vector2.ZERO else deceleration
	velocity = velocity.move_toward(target, rate * delta)
	move_and_slide()


func _unhandled_input(event: InputEvent) -> void:
	if not can_move or _current == null:
		return
	if event.is_action_pressed("interact"):
		get_viewport().set_input_as_handled()
		interacted.emit(_current)


func halt() -> void:
	velocity = Vector2.ZERO


func current_interactable() -> Interactable:
	return _current


func _on_reach_changed(_area: Area2D) -> void:
	var closest: Interactable = null
	var closest_distance: float = INF
	for area in reach.get_overlapping_areas():
		if not area is Interactable or not is_instance_valid(area):
			continue
		var candidate: Interactable = area as Interactable
		var distance: float = global_position.distance_squared_to(candidate.global_position)
		if distance < closest_distance:
			closest_distance = distance
			closest = candidate
	if closest != _current:
		_current = closest
		interactable_changed.emit(_current)