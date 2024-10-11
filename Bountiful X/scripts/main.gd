extends Control

var money = 100
var quota = 20
var timer = 60
var time_left = timer

var seed_count = [0, 0, 0, 0]


@onready var timer_label = $TimerLabel
@onready var quota_label = $QuotaLabel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print('farm ready')
	$Carrot/Quantity.text = "x " + str(seed_count[0])
	$Wheat/Quantity.text = "x " + str(seed_count[1])
	$Pumpkin/Quantity.text = "x " + str(seed_count[2])
	$Corn/Quantity.text = "x " + str(seed_count[3])
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


func _on_carrot_pressed():
	if money >= 10:
		seed_count[0] += 1
		money -= 10
		$Carrot/Quantity.text = "x " + str(seed_count[0])


func _on_wheat_pressed():
	if money >= 5:
		seed_count[1] += 1
		money -= 5
		$Wheat/Quantity.text = "x " + str(seed_count[1])


func _on_pumpkin_pressed():
	if money >= 20:
		seed_count[2] += 1
		money -= 20
		$Pumpkin/Quantity.text = "x " + str(seed_count[2])

func _on_corn_pressed():
	if money >= 15:
		seed_count[3] += 1
		money -= 15
		$Corn/Quantity.text = "x " + str(seed_count[3])
