class_name LightsOut
extends Interactable

signal solved(puzzle: LightsOut)
signal changed()

@export var lit_texture: Texture2D
@export var unlit_texture: Texture2D
@export var title: String = "ENIGMA DAS LUZES"
@export_multiline var hint: String = "Pressione uma luz para alternar ela e as luzes ao lado.\nAcenda todas para revelar a senha."
@export var start_lights: Array[bool] = [true, true, true, false, true, false, false, false, false]
@export var solved_title: String = "SENHA"
@export_multiline var solved_body: String = "Senha"

const GRID_SIZE: int = 3
const CELL_COUNT: int = GRID_SIZE * GRID_SIZE

var lights: Array[bool] = []
var _is_solved: bool = false


func _ready() -> void:
	super()
	if prompt == "Interact":
		prompt = "Jogar"
	lights = start_lights.duplicate()
	if lights.size() != CELL_COUNT:
		push_error("LightsOut start_lights must contain exactly nine values.")
		lights.resize(CELL_COUNT)
		lights.fill(false)


func is_solved() -> bool:
	return _is_solved


func lit_count() -> int:
	var count: int = 0
	for is_lit: bool in lights:
		if is_lit:
			count += 1
	return count


func reset() -> void:
	lights = start_lights.duplicate()
	_is_solved = false
	changed.emit()


func press(index: int) -> void:
	if _is_solved or index < 0 or index >= CELL_COUNT or lights.size() != CELL_COUNT:
		return
	@warning_ignore("integer_division")
	var row: int = index / GRID_SIZE
	var column: int = index % GRID_SIZE
	_toggle_cell(row, column)
	_toggle_cell(row - 1, column)
	_toggle_cell(row + 1, column)
	_toggle_cell(row, column - 1)
	_toggle_cell(row, column + 1)
	changed.emit()
	if _all_lit():
		_is_solved = true
		solved.emit(self)


func _toggle_cell(row: int, column: int) -> void:
	if row < 0 or row >= GRID_SIZE or column < 0 or column >= GRID_SIZE:
		return
	var index: int = row * GRID_SIZE + column
	lights[index] = not lights[index]


func _all_lit() -> bool:
	for is_lit: bool in lights:
		if not is_lit:
			return false
	return true
