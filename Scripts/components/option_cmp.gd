class_name Option
extends Control


@export var point_label: Label
@export var title_label: MatrixLabel
@export var hover_color: Color

signal option_pressed(option:Option)

var is_hovered: bool = false
var question_data: QuestionResource
var question_state: bool

func _ready() -> void:
	mouse_entered.connect(_on_entered)
	mouse_exited.connect(_on_exited)
	pass

func initialize(p_question:QuestionResource, state:bool) -> void:
	question_data = p_question
	point_label.text = str(question_data.value)
	title_label.set_new_text(question_data.title)
	question_state = state
	update_state()
	pass

func set_state(state:bool) -> void:
	question_state = state
	update_state()

func _on_entered() -> void:
	print("Hovered")
	is_hovered = true
	if question_state != false:
		var tween = create_tween()
		tween.tween_property(self, "modulate", hover_color, 0.2)

func _on_exited() -> void:
	is_hovered = false
	if question_state != false:
		var tween = create_tween()
		tween.tween_property(self, "modulate", Color.WHITE, 0.2)

func update_state() -> void:
	var tween = create_tween()
	if question_state == true:
		tween.tween_property(self, "modulate", Color.WHITE, 0.2)
	else :
		tween.tween_property(self, "modulate", Color.from_string("#80000b", Color.BLACK), 0.2)

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and is_hovered and event.button_index == MouseButton.MOUSE_BUTTON_LEFT:
			if question_state != false:
				print("Pressed...")
				option_pressed.emit(self)
