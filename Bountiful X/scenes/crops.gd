extends TileMapLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func update_tile(inv):
	var map_pos = local_to_map(get_local_mouse_position())
	
	if get_cell_source_id(map_pos) == -1:
		set_cell(map_pos, 2, Vector2i(inv - 3, 0))
