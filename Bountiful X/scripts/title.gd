extends Control

@onready var play_button = $Play
@onready var options_button = $Options
@onready var quit_button = $Quit


# Called when the node enters the scene tree for the first time.
func _ready():
	# Connect signals
	$Intro.finished.connect(on_intro_finished)
	play_button.button_down.connect(on_play_button_pressed)
	options_button.button_down.connect(on_options_button_pressed)
	quit_button.button_down.connect(on_quit_button_pressed)
	
	print('title ready')


func on_play_button_pressed():
	print('play')
	get_tree().change_scene_to_file("res://scenes/main.tscn")


func on_options_button_pressed():
	print('open options')
	get_tree().change_scene_to_file('res://scenes/options.tscn')


func on_quit_button_pressed():
	print('quit')
	get_tree().quit()


func on_intro_finished():
	print('intro finished')
	$Intro.queue_free()
	$Loop.play()
