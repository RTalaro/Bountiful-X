extends Control

var money = 100
var quota = 20
var timer = 60
var time_left = timer

var seed_count = [0, 0, 0, 0] # In order: carrot, wheat, pumpkin, corn
var price_list = [10, 5, 20, 15] # In order: carrot, wheat, pumpkin, corn

var previous_discount = 0
var discount = 0


@onready var timer_label = $TimerLabel
@onready var quota_label = $QuotaLabel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Intro.finished.connect(on_intro_finished)
	
	$Water/SelectInv.visible = false
	$Till/SelectInv.visible = false
	$Carrot/SelectInv.visible = false
	$Wheat/SelectInv.visible = false
	$Pumpkin/SelectInv.visible = false
	$Corn/SelectInv.visible = false
	
	update_text()
	print('farm ready')
	
	start_timer()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta) -> void:
	if time_left > 0:
		time_left -= delta
		timer_label.text = str(floor(time_left)) + "s"
		quota_label.text = "$" + str(quota)
	else:
		check_quota()
		
func select_inv_updater():
	$Water/SelectInv.visible = false
	$Till/SelectInv.visible = false
	
	$Carrot/SelectInv.visible = false
	$Wheat/SelectInv.visible = false
	$Pumpkin/SelectInv.visible = false
	$Corn/SelectInv.visible = false
	
	if $Farm.inventory_num == 1:
		$Water/SelectInv.visible = true
	elif $Farm.inventory_num == 2:
		$Till/SelectInv.visible = true
	elif $Farm.inventory_num == 3:
		$Carrot/SelectInv.visible = true
	elif $Farm.inventory_num == 4:
		$Wheat/SelectInv.visible = true
	elif $Farm.inventory_num == 5:
		$Pumpkin/SelectInv.visible = true
	elif $Farm.inventory_num == 6:
		$Corn/SelectInv.visible = true


func start_timer() -> void:
	time_left = timer


func check_quota() -> void:
	if money >= quota:
		print('quota met')
		money -= quota
		quota += 20
		start_timer()
	else:
		get_tree().change_scene_to_file("res://scenes/title.tscn")

func update_text():
	$Carrot/Quantity.text = "x " + str(seed_count[0])
	$Carrot/Cost.text = str(price_list[0]) + " gold"
	$Wheat/Quantity.text = "x " + str(seed_count[1])
	$Wheat/Cost.text = str(price_list[1]) + " gold"
	$Pumpkin/Quantity.text = "x " + str(seed_count[2])
	$Pumpkin/Cost.text = str(price_list[2]) + " gold"
	$Corn/Quantity.text = "x " + str(seed_count[3])
	$Corn/Cost.text = str(price_list[3]) + " gold"
# Button signals from the shop, all do pretty much the same thing, buying a seed type and incrementing the seed count
func _on_carrot_pressed() -> void:
	if money >= price_list[0]:
		seed_count[0] += 1
		money -= price_list[0]
		$Carrot/Quantity.text = "x " + str(seed_count[0])


func _on_wheat_pressed() -> void:
	if money >= price_list[1]:
		seed_count[1] += 1
		money -= price_list[1]
		$Wheat/Quantity.text = "x " + str(seed_count[1])


func _on_pumpkin_pressed() -> void:
	if money >= price_list[2]:
		seed_count[2] += 1
		money -= price_list[2]
		$Pumpkin/Quantity.text = "x " + str(seed_count[2])

func _on_corn_pressed() -> void:
	if money >= price_list[3]:
		seed_count[3] += 1
		money -= price_list[3]
		$Corn/Quantity.text = "x " + str(seed_count[3])

func on_intro_finished():
	print('intro finished')
	$Intro.queue_free()
	$Loop.play()
	

func _on_sale_timer_timeout():
	price_list[previous_discount] += discount # Restoring prices for previously discounted crop
	var random = randi_range(0, 3)
	previous_discount = random
	discount = int(price_list[random] * 0.4)
	price_list[random] -= discount
	update_text()


func _on_water_pressed() -> void:
	$Farm.inventory_num = 1


func _on_till_pressed() -> void:
	$Farm.inventory_num = 2
