class_name Question
extends Control

signal go_back_pressed
#Labels:
@export var question_label : Label
@export var answer_label : Label
#images
@export var question_image: TextureRect
@export var answer_image: TextureRect
#Hints:
@export var hint_container: Control
@export var hint_holder: Control

@export var animator : AnimationPlayer
#buttons:
@export var show_answer_button : Button
@export var show_hint_button : Button
@export var go_back_button : Button

var question_data:QuestionResource
var is_showing : bool = false
var is_showing_hints: bool = false

func _ready() -> void:
	show_answer_button.pressed.connect(on_show_pressed)
	show_hint_button.pressed.connect(on_show_hint_pressed)
	go_back_button.pressed.connect(on_back_pressed)
	#hint_container.visible
	pass

func on_back_pressed() -> void:
	is_showing = false
	show_answer_button.text = "Show Answer"
	hide_hints()
	show_question()

	go_back_pressed.emit()

func on_show_pressed() -> void:
	if is_showing:
		is_showing = false
		show_answer_button.text = "Show Answer"
		show_question()
	else:
		is_showing = true
		show_answer_button.text = "Show Question"
		show_answer()

func on_show_hint_pressed() -> void:
	if question_data.has_choice:
		hint_container.visible = true

		if is_showing_hints:
			is_showing_hints = false
			hide_hints()
		else:
			is_showing_hints = true
			var hints : Array[String] = question_data.hints.Choices
			for hint in hints:
				var new_hint = Label.new()
				new_hint.text = hint
				hint_holder.add_child(new_hint)


func hide_hints() -> void:
	hint_container.visible = false
	for child in hint_holder.get_children():
		child.queue_free()

func show_answer() -> void:
	animator.play("show_answer")

func show_question() -> void:
	animator.play("show_question")

func initialize(p_question: QuestionResource) -> void:
	hide_hints()
	question_data = p_question
	#Hint Button:
	if question_data.has_choice:
		show_hint_button.visible = true
	else :
		show_hint_button.visible = false

	question_label.text = question_data.question
	answer_label.text = question_data.answer
	question_image.texture = p_question.question_image
	answer_image.texture = p_question.answer_image
