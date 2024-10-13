extends TileMapLayer

# Used to keep track of how long much longer it'll take for a seed to grow
# Works since get_used_tiles returns based on when they were placed so time_left will always match
# if an item is added when a seed is also placed
var time_left = [] 
var time_left_final = [] 


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func update_tile(inv):
	var map_pos = local_to_map(get_local_mouse_position())
	var boost = 0
	
	if inv == 1:
		if get_cell_source_id(map_pos) == 0:
			if get_cell_atlas_coords(map_pos) == Vector2i(0, 0):
				if !has_surrounding(map_pos):
					boost = 2
			if get_cell_atlas_coords(map_pos) == Vector2i(2, 0):
				if has_surrounding_pumpkin(map_pos):
					boost = 3
			time_left_final.append(get_cell_tile_data(map_pos).get_custom_data("time") - boost)
	
	if get_parent().get_parent().get_parent().seed_count[inv - 3] > 0: # Checking if the player has enough seeds to even plant
		if get_cell_source_id(map_pos) == -1:
			if inv == 3: # Checks if it's a carrot and if there's nothing surrounding then it gets a small buff
				if !has_surrounding(map_pos):
					boost = 3
			if inv == 5: # Checks if it's a punpkin and if there's at least one surrounding carrot then it gets a small buff
				if has_surrounding_pumpkin(map_pos):
					boost = 5
			set_cell(map_pos, 2, Vector2i(inv - 3, 0)) 
			time_left.append(get_cell_tile_data(map_pos).get_custom_data("time") - boost)
			#print(time_left)
			get_parent().get_parent().get_parent().seed_count[inv - 3] -= 1
			get_parent().get_parent().get_parent().update_text()


func grow_tile(pos): # "grows" seed into baby crop
	get_parent().set_cell(pos, 0, Vector2i(2, 0))
	set_cell(pos, 0, get_cell_atlas_coords(pos))
	
func grow_tile_final(pos): # "grows" seed into crop allowing it to be harvested for money
	set_cell(pos, 1, get_cell_atlas_coords(pos))


func has_surrounding(map_pos): # Checks if there's any seed or crop surrounding
	for i in get_surrounding_cells(map_pos):
		if get_cell_atlas_coords(i) != Vector2i(-1, -1):
			return true
	return false


func has_surrounding_pumpkin(map_pos): # Checks if the surrounding tiles has a pumpkin seed / crop
	for i in get_surrounding_cells(map_pos):
		if get_cell_atlas_coords(i) == Vector2i(2, 0):
			return true
	return false


# Slowly decrements the time in time_left, when the time hits zero it is removed from time_left and the corresponding seed grows
func _on_timer_timeout(): 
	for i in range(time_left.size() - 1, -1, -1):
		time_left[i] -= 1
		if time_left[i] <= 0:
			grow_tile(get_used_cells_by_id(2)[i])
			time_left.remove_at(i)
			
	for i in range(time_left_final.size() - 1, -1, -1):
		time_left_final[i] -= 1
		if time_left_final[i] <= 0:
			grow_tile_final(get_used_cells_by_id(0)[i])
			time_left_final.remove_at(i)
	#print(time_left)
