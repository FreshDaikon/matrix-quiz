class_name MatrixLabel
extends Label

@export var interval: float = 0.05  # seconds between letter flips

var _original_text: String = ""
var _chars: Array = []
var _timer: float = 0.0
var _index: int = 0
var _animating: bool = false

func _ready():
	_original_text = text
	text = _original_text.to_lower()
	mouse_filter = Control.MOUSE_FILTER_PASS
	mouse_entered.connect(_on_hover)
	_on_hover()
	set_process(true)

func _process(delta):
	if not _animating:
		return

	_timer += delta
	if _timer >= interval:
			_timer = 0.0
			if _index < _chars.size():
				var current = _chars[_index]
				if current.is_valid_identifier() or current.is_subsequence_of("abcdefghijklmnopqrstuvwxyz"):
					_chars[_index] = current.to_upper()
				text = "".join(_chars)
				_index += 1
			else:
				_animating = false

func set_new_text(new_text:String) -> void:
	_original_text = new_text
	_on_hover()

func _on_hover():
	# Restart animation
	_chars = _original_text.to_lower().split("")
	_index = 0
	_timer = 0.0
	_animating = true
	text = "".join(_chars)
