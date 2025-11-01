class_name Player
extends Control

@export var player_pfp : TextureRect
@export var player_name : Label
@export var point_label : Label

@export var full_button : Button
@export var half_button : Button


var data : PlayerData
var points : int = 0

var current_point_value : int = 0

func _ready() -> void:
	full_button.pressed.connect(grant_points_full)
	half_button.pressed.connect(grant_points_half)


func initialize(p_data: PlayerData) -> void:
	data = p_data
	#setup:
	player_pfp.texture = data.player_pfp
	player_name.text = data.player_name
	point_label.text = str(points)

func grant_points_full() -> void:
	points += current_point_value
	point_label.text = str(points)

func grant_points_half() -> void:
	points = points + (current_point_value / 2)
	point_label.text = str(points)

func set_current_point_value(value:int) -> void:
	current_point_value = value
