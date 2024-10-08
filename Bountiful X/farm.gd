extends Control

var inventory_num = 0
# 1 till soil, 2 water plants, 3 wheat, 4 corn, 5 parsnip (?), 6 carrots


# Called when the node enters the scene tree for the first time.
func _ready():
	print('farm ready')


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if event is InputEventKey and event.pressed:
		if int(event.as_text()) < 7:
			inventory_num = 2 * int(event.as_text()) - 2
	
	if event is InputEventMouseButton and event.pressed:
		$Dirt.update_tile(event.position)
	
