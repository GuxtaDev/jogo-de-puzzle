class_name Ending
extends Node2D

const TEXT_COLOR := Color(0.95, 0.98, 1.0, 1.0)
const HIGHLIGHT_COLOR := Color(0.45, 0.8, 1.0, 1.0)
const DIM_COLOR := Color(0.55, 0.66, 0.82, 1.0)
const GLOW_COLOR := Color(0.42, 0.68, 1.0, 0.4)

const TITLE_SCALE := 4
const MESSAGE_SCALE := 3
const MESSAGE_MAX_WIDTH := 760
const FOOTER_SCALE := 2

const FOOTER_TEXT := "[E] sair"

@onready var _title: TextureRect = $Interface/Center/Panel/VBox/Title
@onready var _message: TextureRect = $Interface/Center/Panel/VBox/Message
@onready var _footer: TextureRect = $Interface/Center/Panel/VBox/Footer

var _closing: bool = false


func _ready() -> void:
	_title.texture = PixelText.make_rich("O FIM", TEXT_COLOR, HIGHLIGHT_COLOR, GLOW_COLOR, 0, TITLE_SCALE, 0)
	_message.texture = PixelText.make_rich(
		"Obrigado por jogar, mais desafios em breve!",
		TEXT_COLOR, HIGHLIGHT_COLOR, GLOW_COLOR, MESSAGE_MAX_WIDTH, MESSAGE_SCALE, 14)
	_footer.texture = PixelText.make_rich(FOOTER_TEXT, DIM_COLOR, HIGHLIGHT_COLOR, GLOW_COLOR, 0, FOOTER_SCALE, 0)


func _unhandled_input(event: InputEvent) -> void:
	if _closing:
		return
	if event.is_action_pressed("interact") or event.is_action_pressed("ui_cancel"):
		_closing = true
		get_viewport().set_input_as_handled()
		get_tree().quit()