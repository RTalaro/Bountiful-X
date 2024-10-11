extends TileMapLayer

var time_left = []


# Called when the node enters the scene tree for the first time.
func _ready():
	set_cell(Vector2i(1, 1), 1, Vector2i(0, 0))
	pass # Replace with function body.


func update_tile(inv):
	var map_pos = local_to_map(get_local_mouse_position())
	
	if get_cell_source_id(map_pos) == -1:
		set_cell(map_pos, 2, Vector2i(inv - 3, 0))
		time_left.append(get_cell_tile_data(map_pos).get_custom_data("time"))
	
func grow_tile(pos):
	set_cell(pos, 1, get_cell_atlas_coords(pos))

func _on_timer_timeout():
	for i in range(time_left.size()):
		time_left[i - 1] -= 1
		if time_left[i - 1] == 0:
			grow_tile(get_used_cells_by_id(2)[i])
			time_left.remove_at(i)
