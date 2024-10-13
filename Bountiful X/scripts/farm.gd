extends Control

@export var rows = 8
@export var cols = 8
@export var tile_size = 16

var inventory_num = 0 #1 water plants, 2 till soil, 3 carrot, 4 wheat, 5 pumpkin, 6 corn

# Called when the node enters the scene tree for the first time.
func _ready():
	# Adjusts position so the game is centered
	self.position.x -= (tile_size * rows * self.scale.x) / 2 
	self.position.y -= (tile_size * cols * self.scale.y) / 2

func _input(event):
	# two events, one for mouse one for switching
	if event is InputEventKey and event.pressed:
		if int(event.as_text()) < 7: # Switches the item that the player is holding with the corresponding number
			inventory_num = int(event.as_text())
			get_parent().select_inv_updater()
			# tool_icon[inventory_num].scale = Vector2(0.05, 0.05)
			# Input.set_custom_mouse_cursor(tool_icon[inventory_num])
	
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			$Dirt.update_tile(inventory_num)
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			$Dirt.harvest_tile()
			
