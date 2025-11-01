class_name Category
extends Control

@export var category_label: Label
@export var category_image: TextureRect

var data:CategoryResource
var question_states: Dictionary

signal category_pressed(catogory:Category)

var is_hovered: bool = false

func _ready() -> void:
	print("hello world")
	mouse_entered.connect(on_mouse_enter)
	mouse_exited.connect(on_mouse_exit)

func initialize(p_cat:CategoryResource)->void:
	data = p_cat
	category_label.text = data.category_name
	category_image.texture = data.category_image
	setup_category_states()

func on_mouse_enter():
	print("Hovering Category")
	is_hovered = true

func on_mouse_exit():
	print("unhovering data")
	is_hovered = false

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and is_hovered and event.button_index == MouseButton.MOUSE_BUTTON_LEFT:
			print("Pressed...")
			category_pressed.emit(self)

func setup_category_states() -> void:
	for question in data.questions:
		question_states[question] = true

func get_question_state(question : QuestionResource) -> bool:
	return question_states[question]

func set_question_state(question: QuestionResource, new_state: bool) -> void:
	question_states[question] = new_state
