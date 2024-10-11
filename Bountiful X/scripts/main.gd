extends Control

var money = 100
var quota = 20
var timer = 60
var time_left = timer

var seed_count = [0, 0, 0, 0] # In order: carrot, wheat, pumpkin, corn


@onready var timer_label = $TimerLabel
@onready var quota_label = $QuotaLabel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Intro.finished.connect(on_intro_finished)
	
	$Carrot/Quantity.text = "x " + str(seed_count[0])
	$Carrot/Cost.text = "10 gold"
	$Wheat/Quantity.text = "x " + str(seed_count[1])
	$Wheat/Cost.text = "5 gold"
	$Pumpkin/Quantity.text = "x " + str(seed_count[2])
	$Pumpkin/Cost.text = "20 gold"
	$Corn/Quantity.text = "x " + str(seed_count[3])
	$Corn/Cost.text = "15 gold"
	print('farm ready')
	
	start_timer()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta) -> void:
	if time_left > 0:
		time_left -= delta
		timer_label.text = "Time left: " + str(floor(time_left))
		quota_label.text = "Quota: $" + str(quota) + " | Money: $" + str(money)
	else:
		check_quota()


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

# Button signals from the shop, all do pretty much the same thing, buying a seed type and incrementing the seed count
func _on_carrot_pressed() -> void:
	if money >= 10:
		seed_count[0] += 1
		money -= 10
		$Carrot/Quantity.text = "x " + str(seed_count[0])


func _on_wheat_pressed() -> void:
	if money >= 5:
		seed_count[1] += 1
		money -= 5
		$Wheat/Quantity.text = "x " + str(seed_count[1])


func _on_pumpkin_pressed() -> void:
	if money >= 20:
		seed_count[2] += 1
		money -= 20
		$Pumpkin/Quantity.text = "x " + str(seed_count[2])

func _on_corn_pressed() -> void:
	if money >= 15:
		seed_count[3] += 1
		money -= 15
		$Corn/Quantity.text = "x " + str(seed_count[3])

func on_intro_finished():
	print('intro finished')
	$Intro.queue_free()
	$Loop.play()
	
