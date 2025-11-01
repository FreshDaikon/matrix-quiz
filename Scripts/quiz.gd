class_name Quiz
extends Node

#References:
#containers:
@export var categories_container : Control
@export var options_container : Control
@export var question_container : Control
#holders:
@export var category_holder:Control
@export var options_holder:Control
@export var player_holder: Control
#question:
@export var question_component: Question
@export var category_label: MatrixLabel
#buttons :
@export var options_back: Button


#Data:
@export var categories : Array[CategoryResource] = []
@export var players : Array[PlayerData] = []
#Packed Scenes:
@export var category_scene: PackedScene #Must be a Category Type!
@export var option_scene: PackedScene
@export var question_scene: PackedScene #Must be a Question Type!
@export var player_scene: PackedScene


func _ready() -> void:
	#spawn categories:
	for cat in categories:
		var new_cat:Category = spawn_category()
		new_cat.initialize(cat)
		new_cat.category_pressed.connect(_on_category_pressed)
		category_holder.add_child(new_cat)
	#setup Players:
	for player_data in players:
		var new_player:Player = player_scene.instantiate()
		new_player.initialize(player_data)
		player_holder.add_child(new_player)
	#setup buttons:
	options_back.pressed.connect(hide_category_options)
	question_component.go_back_pressed.connect(hide_question)


func _on_category_pressed(category: Category)-> void:
	print("pressed category {cat}".format({"cat": category.data.category_name}))
	show_category_options(category)
	pass

func spawn_category()->Category:
	var new_category:Category = category_scene.instantiate()
	return new_category

func spawn_question()-> Question:
	var new_question:Question = question_scene.instantiate()
	return new_question


func show_category_options(category:Category)->void :
	options_container.visible = true
	var cat_tween = create_tween()
	await cat_tween.tween_property(categories_container, "modulate", Color.TRANSPARENT , 0.2).finished
	#clean old options:
	for child in options_holder.get_children():
		child.queue_free()

	#populate:
	for question in category.data.questions:
		var new_option:Option = option_scene.instantiate()
		options_holder.add_child(new_option)
		var current_state = category.get_question_state(question)
		new_option.initialize(question, current_state)
		new_option.option_pressed.connect(show_question.bind(category))

	#More Tweening:
	print("pressed category {cat}".format({"cat": category.data.category_name}))
	category_label.set_new_text(category.data.category_name)
	var options_tween = create_tween()
	await options_tween.tween_property(options_container, "modulate", Color.WHITE, 0.2).finished

func hide_category_options()-> void:
	var options_tween = create_tween()
	await options_tween.tween_property(options_container, "modulate", Color.TRANSPARENT, 0.2).finished
	options_container.visible = false
	var cat_tween = create_tween()
	await cat_tween.tween_property(categories_container, "modulate", Color.WHITE , 0.2).finished


func show_question(option:Option, category:Category) -> void:
	question_container.visible = true
	question_component.initialize(option.question_data)
	#option
	category.set_question_state(option.question_data, false)
	option.set_state(false)
	for player in player_holder.get_children():
		if player is Player:
			player.set_current_point_value(option.question_data.value)
	# Tweens:
	var options_tween = create_tween()
	await options_tween.tween_property(options_container, "modulate", Color.TRANSPARENT, 0.2).finished
	var question_tween = create_tween()
	await question_tween.tween_property(question_container, "modulate", Color.WHITE , 0.2).finished

func hide_question() -> void:
	#Setup Question Component:
	var question_tween = create_tween()
	await question_tween.tween_property(question_container, "modulate", Color.TRANSPARENT , 0.2).finished
	question_container.visible = false
	#Show Options again:
	var options_tween = create_tween()
	await options_tween.tween_property(options_container, "modulate", Color.WHITE, 0.2).finished
