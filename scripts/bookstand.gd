class_name Bookstand
extends Interactable

@export var titles: PackedStringArray = PackedStringArray()
@export var bodies: PackedStringArray = PackedStringArray()

@export var bob_height: float = 2.0
@export var bob_speed: float = 1.8

var _time: float = 0.0
var _book_home: Vector2 = Vector2.ZERO

@onready var book: Sprite2D = $Book
@onready var book_glow: Sprite2D = $BookGlow
@onready var lamp: PointLight2D = $Lamp


func _ready() -> void:
	super()
	if prompt == "Interact":
		prompt = "Ler"
	_book_home = book.position


func _process(delta: float) -> void:
	_time += delta
	var hover: Vector2 = _book_home + Vector2(0.0, sin(_time * bob_speed) * bob_height)
	book.position = hover
	book_glow.position = hover
	lamp.position = hover
	book_glow.modulate.a = 0.8 + sin(_time * 1.3) * 0.2


func page_count() -> int:
	return maxi(titles.size(), bodies.size())


func page_title(index: int) -> String:
	if index >= 0 and index < titles.size():
		return titles[index]
	return ""


func page_body(index: int) -> String:
	if index >= 0 and index < bodies.size():
		return bodies[index]
	return ""
