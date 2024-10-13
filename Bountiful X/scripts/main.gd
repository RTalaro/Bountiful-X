extends Control

var money = 50
var quota = 20
var increasing = 0
var timer = 30
var time_left = timer
var round = 0

var seed_count = [0, 0, 0, 0] # In order: carrot, wheat, pumpkin, corn
var price_list = [10, 5, 20, 15] # In order: carrot, wheat, pumpkin, corn

var previous_discount = 0
var discount = 0


@onready var timer_label = $TimerLabel
@onready var quota_label = $QuotaLabel
@onready var money_label = $MoneyLabel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	quota_label.text = "$" + str(quota)
	money_label.text = "$" + str(money)
	$Intro.finished.connect(on_intro_finished)
	
	$Water/SelectInv.visible = false
	$Till/SelectInv.visible = false
	$Carrot/SelectInv.visible = false
	$Wheat/SelectInv.visible = false
	$Pumpkin/SelectInv.visible = false
	$Corn/SelectInv.visible = false
	
	update_text()
	#print('farm ready')
	
	start_timer()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta) -> void:
	if time_left > 0:
		time_left -= delta
		timer_label.text = str(floor(time_left)) + "s"
	else:
		check_quota()
		
func select_inv_updater():
	money_label.text = "$" + str(money)
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
		#print('quota met')
		round += 1
		money -= quota
		quota += 30 + increasing
		increasing += 10
		quota_label.text = "$" + str(quota)
		start_timer()
	else:
		$"Discord-notification".play()
		$SaleLabel.visible = true
		$Popup.visible = true
		$SaleLabel.text = "You survived " + str(round) + " rounds."
		$Reset.start()
		get_tree().paused = true

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
	$Farm.inventory_num = 3
	if money >= price_list[0]:
		seed_count[0] += 1
		money -= price_list[0]
		$Carrot/Quantity.text = "x " + str(seed_count[0])
	select_inv_updater()


func _on_wheat_pressed() -> void:
	$Farm.inventory_num = 4
	if money >= price_list[1]:
		seed_count[1] += 1
		money -= price_list[1]
		$Wheat/Quantity.text = "x " + str(seed_count[1])
	select_inv_updater()


func _on_pumpkin_pressed() -> void:
	$Farm.inventory_num = 5
	if money >= price_list[2]:
		seed_count[2] += 1
		money -= price_list[2]
		$Pumpkin/Quantity.text = "x " + str(seed_count[2])
	select_inv_updater()

func _on_corn_pressed() -> void:
	$Farm.inventory_num = 6
	if money >= price_list[3]:
		seed_count[3] += 1
		money -= price_list[3]
		$Corn/Quantity.text = "x " + str(seed_count[3])
	select_inv_updater()

func on_intro_finished():
	#print('intro finished')
	$Intro.queue_free()
	$Loop.play()
	
func sale_notification(crop):
	$"Discord-notification".play()
	$SaleLabel.visible = true
	$Popup.visible = true
	$SaleEnd.start(4)
	if crop == 0:
		$SaleLabel.text = "Carrots are now on sale!"
	elif crop == 1:
		$SaleLabel.text = "Wheat is now on sale!"
	elif crop == 2:
		$SaleLabel.text = "Pumpkins are now on sale!"
	elif crop == 3:
		$SaleLabel.text = "Corn is now on sale!"

func _on_sale_timer_timeout():
	price_list[previous_discount] += discount # Restoring prices for previously discounted crop
	var random = randi_range(0, 3)
	sale_notification(random)
	previous_discount = random
	discount = int(price_list[random] * 0.4)
	price_list[random] -= discount
	update_text()


func _on_water_pressed() -> void:
	$Farm.inventory_num = 1


func _on_till_pressed() -> void:
	$Farm.inventory_num = 2


func _on_sale_end_timeout():
	$SaleLabel.visible = false
	$Popup.visible = false


func _on_reset_timeout():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/title.tscn")
