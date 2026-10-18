class_name LightsOut
extends Interactable
## A 3x3 Lights Out puzzle. Pressing one lamp toggles it and its orthogonal neighbors.

signal solved(puzzle: LightsOut)

@export var lit_texture: Texture2D
@export var unlit_texture: Texture2D
@export var start_lights: Array[bool] = [true, true, true, false, true, false, false, false, false]
@export var solved_title: String = "SENHA"
@export_multiline var solved_body: String = "Senha"

const GRID_SIZE: int = 3
const CELL_COUNT: int = GRID_SIZE * GRID_SIZE

var lights: Array[bool] = []
var _buttons: Array[Button] = []
var _is_solved: bool = false
var _player_in_range: bool = false

@onready var _status_label: Label = $Status
@onready var _prompt_label: Label = $Prompt
@onready var _area_shape: CollisionShape2D = $Shape


func _ready() -> void:
	prompt = "Jogar"
	collision_layer = 4
	collision_mask = 2
	add_to_group("interactable")
	lights = start_lights.duplicate()
	if lights.size() != CELL_COUNT:
		push_error("LightsOut start_lights must contain exactly nine values.")
		return
	set_physics_process(true)
	for index: int in CELL_COUNT:
		var button: Button = get_node("Grid/Cell%d" % index) as Button
		_buttons.append(button)
		button.mouse_filter = Control.MOUSE_FILTER_STOP
		button.pressed.connect(_on_cell_pressed.bind(index))
		_refresh_button(index)
	_refresh_status()
	_refresh_prompt()


func _physics_process(_delta: float) -> void:
	var player: Player = get_tree().get_first_node_in_group("player") as Player
	if player == null:
		return
	var detection_shape: RectangleShape2D = _area_shape.shape as RectangleShape2D
	if detection_shape == null:
		return
	var half_size: Vector2 = detection_shape.size * 0.5
	var player_in_local_space: Vector2 = to_local(player.global_position)
	var in_range: bool = absf(player_in_local_space.x) <= half_size.x + 60.0 and absf(player_in_local_space.y) <= half_size.y + 60.0
	if in_range == _player_in_range:
		return
	_player_in_range = in_range
	_refresh_prompt()
	if not _player_in_range:
		get_viewport().gui_release_focus()


func _on_cell_pressed(index: int) -> void:
	if _is_solved or not _player_in_range:
		return
	if _buttons[index].has_focus():
		_buttons[index].release_focus()
	var row: int = floori(float(index) / float(GRID_SIZE))
	var column: int = index % GRID_SIZE
	_toggle_cell(row, column)
	_toggle_cell(row - 1, column)
	_toggle_cell(row + 1, column)
	_toggle_cell(row, column - 1)
	_toggle_cell(row, column + 1)
	for cell_index: int in CELL_COUNT:
		_refresh_button(cell_index)
	if _all_lit():
		_is_solved = true
		_prompt_label.text = "ENIGMA RESOLVIDO"
		_status_label.text = "TODAS AS LUZES ACESAS"
		solved.emit(self)
	else:
		_refresh_status()


func _toggle_cell(row: int, column: int) -> void:
	if row < 0 or row >= GRID_SIZE or column < 0 or column >= GRID_SIZE:
		return
	var index: int = row * GRID_SIZE + column
	lights[index] = not lights[index]


func _refresh_button(index: int) -> void:
	var button: Button = _buttons[index]
	var texture: Texture2D = lit_texture if lights[index] else unlit_texture
	button.icon = texture
	button.modulate = Color.WHITE if lights[index] else Color(0.68, 0.74, 0.86, 1)


func _refresh_status() -> void:
	var lit_count: int = 0
	for is_lit: bool in lights:
		if is_lit:
			lit_count += 1
	_status_label.text = "ACESAS: %d / 9" % lit_count


func _refresh_prompt() -> void:
	_prompt_label.visible = _player_in_range and not _is_solved


func _all_lit() -> bool:
	for is_lit: bool in lights:
		if not is_lit:
			return false
	return true
