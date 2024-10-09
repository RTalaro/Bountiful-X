extends Control



var inventory_num = 0
# 1 till soil, 2 water plants, 3 wheat, 4 corn, 5 parsnip (?), 6 carrots
var money = 0
var quota = 20
var timer = 60
var time_left = timer

@onready var timer_label = $TimerLabel
@onready var quota_label = $QuotaLabel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
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
		pass # Game over screen would be implemented here


func _input(event) -> void:
	if event is InputEventKey and event.pressed:
		if int(event.as_text()) < 7:
			inventory_num = 2 * int(event.as_text()) - 2
	
	if event is InputEventMouseButton and event.pressed:
		$Dirt.update_tile(event.position)
	
