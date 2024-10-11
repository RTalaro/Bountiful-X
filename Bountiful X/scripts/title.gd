extends Control

@onready var play_button = $MarginContainer/VBoxContainer2/VBoxContainer/Play
@onready var options_button = $MarginContainer/VBoxContainer2/VBoxContainer/Options
@onready var quit_button = $MarginContainer/VBoxContainer2/VBoxContainer/Quit


# Called when the node enters the scene tree for the first time.
func _ready():
	# Connect signals
	play_button.button_down.connect(on_play_button_pressed)
	options_button.button_down.connect(on_options_button_pressed)
	quit_button.button_down.connect(on_quit_button_pressed)
	
	print('title ready')


func on_play_button_pressed():
	print('play')
	get_tree().change_scene_to_file('res://farm.tscn')


func on_options_button_pressed():
	print('open options')
	get_tree().change_scene_to_file('res://options.tscn')


func on_quit_button_pressed():
	print('quit')
	get_tree().quit()
