extends TileMapLayer

var time_left = []


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func update_tile(inv):
	var map_pos = local_to_map(get_local_mouse_position())
	var boost = 0
	
	if get_cell_source_id(map_pos) == -1:
		if inv == 5:
			if !has_surrounding(map_pos):
				boost = 4
		if inv == 3:
			if has_surrounding_carrot(map_pos):
				boost = 5
		set_cell(map_pos, 2, Vector2i(inv - 3, 0)) 
		time_left.append(get_cell_tile_data(map_pos).get_custom_data("time") - boost)
		print(time_left)
	
func grow_tile(pos):
	set_cell(pos, 1, get_cell_atlas_coords(pos))

func has_surrounding(map_pos):
	for i in get_surrounding_cells(map_pos):
		if get_cell_atlas_coords(i) != Vector2i(-1, -1):
			return true
	return false

func has_surrounding_carrot(map_pos):
	for i in get_surrounding_cells(map_pos):
		if get_cell_atlas_coords(i) == Vector2i(0, 0):
			return true
	return false

func _on_timer_timeout():
	for i in range(time_left.size() - 1, -1, -1):
		time_left[i] -= 1
		if time_left[i] <= 0:
			grow_tile(get_used_cells_by_id(2)[i])
			time_left.remove_at(i)
	print(time_left)
