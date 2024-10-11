extends TileMapLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var mouse_position := local_to_map(get_local_mouse_position())
	clear()
	if get_parent().get_cell_tile_data(mouse_position) != null:
		set_cell(mouse_position, 0, Vector2i(0, 0))
