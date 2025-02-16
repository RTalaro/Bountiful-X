extends TileMapLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	for y in range(get_parent().rows): # Places the dirt in the middle as well as centers it
		for x in range(get_parent().cols):
			set_cell(Vector2i(x, y), 0, Vector2i(0, 0))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func update_tile(inv):
	var map_pos = local_to_map(get_local_mouse_position())
	
	if get_cell_tile_data(map_pos) != null:
		if inv == 1 or inv > 3:
			if get_cell_atlas_coords(map_pos).x == 2:
				$Crop.update_tile(inv)
		if inv > 0 and inv <= 2: # If holding tool to water or till soil
			if get_cell_atlas_coords(map_pos).x == 0: # If cell is "empty," till or water it
				set_cell(map_pos, 0, Vector2i(inv, 0))
			elif get_cell_atlas_coords(map_pos).x != inv: # If cell is tilled or watered and the opposite is being placed, make cell "plantable"
				set_cell(map_pos, 0, Vector2i(3, 0))
		else: # If not holding tool, player must be holding a seed
			if get_cell_atlas_coords(map_pos).x == 3: # If cell is "plantable"
				$Crop.update_tile(inv)

func harvest_tile():
	var map_pos = local_to_map(get_local_mouse_position())
	
	var data = $Crop.get_cell_tile_data(map_pos)
	if $Crop.get_cell_source_id(map_pos) == 1: # Checks if the crop is grown
		if $Crop.get_cell_atlas_coords(map_pos).x == 3:
			get_parent().get_parent().money += data.get_custom_data("price")
			$Crop.grow_tile(map_pos)
		else:
			get_parent().get_parent().money += data.get_custom_data("price")
			get_parent().get_parent().money_label.text = "$" + str(get_parent().get_parent().money)
			$Crop.erase_cell(map_pos) # Removes crop and resets dirt back to empty
			set_cell(map_pos, 0, Vector2i(0, 0))
		
