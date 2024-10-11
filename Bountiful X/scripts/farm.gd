extends Control

@export var rows = 9
@export var cols = 9
@export var tile_size = 16

var inventory_num = 0 #1 water plants, 2 till soil, 3 wheat, 4 corn, 5 parsnip, 6 carrots


# Called when the node enters the scene tree for the first time.
func _ready():
	self.position.x -= (tile_size * rows * self.scale.x) / 2
	self.position.y -= (tile_size * cols * self.scale.y) / 2

func _input(event):
	# two events, one for mouse one for switching
	if event is InputEventKey and event.pressed:
		if int(event.as_text()) < 7:
			inventory_num = int(event.as_text())
	
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			$Dirt.update_tile(inventory_num)
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			$Dirt.harvest_tile()
