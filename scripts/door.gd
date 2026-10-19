class_name Door
extends Interactable

signal unlocked(door: Door)

@export var title: String = "Sealed Door"
@export_multiline var hint: String = ""

@export var password: String = ""

@export_file("*.tscn") var destination: String = ""

var is_open: bool = false

@onready var sprite: AnimatedSprite2D = $Sprite2D
@onready var blocker: StaticBody2D = $Blocker


func _ready() -> void:
	super()
	if prompt == "Interact":
		prompt = "Examinar"


func check_password(attempt: String) -> bool:
	if password.strip_edges().is_empty():
		return false
	var cleaned: String = attempt.strip_edges().to_lower()
	return cleaned == password.strip_edges().to_lower()


func unlock() -> void:
	if is_open:
		return
	is_open = true
	blocker.set_deferred("collision_layer", 0)
	sprite.play("open")
	unlocked.emit(self)
