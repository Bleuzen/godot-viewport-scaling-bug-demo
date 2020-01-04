# Inspired by: https://gist.github.com/CowThing/2f091036457da281c546937bc8fad695

extends Node

onready var _container : ViewportContainer = $ViewportContainer
onready var _viewport : Viewport = $ViewportContainer/Viewport
onready var _background : ColorRect = $ColorRect


const base_size : = Vector2(320, 180)
const expand : = false
const int_scale : = false
const background_color : = Color(0, 0, 0, 1)


func _ready() -> void:
	get_tree().connect("screen_resized", self, "_on_screen_resized")

	_on_screen_resized()


func _on_screen_resized() -> void:
	var new_window_size : = OS.window_size
	
	var total_base_size : Vector2 = base_size
	
	var scale

	if int_scale:
		var scale_width = max(1, new_window_size.x / total_base_size.x)
		var scale_height = max(1, new_window_size.y / total_base_size.y)
		scale = min(scale_width, scale_height) as int
	else:
		var scale_width = new_window_size.x / total_base_size.x
		var scale_height = new_window_size.y / total_base_size.y
		scale = min(scale_width, scale_height)
	
	var size : Vector2 = new_window_size / scale if expand else total_base_size
	size = size.floor()
	
	var offset : Vector2 = (new_window_size - size * scale) * 0.5
	offset = offset.floor()

	_viewport.size = (size * scale)
	_viewport.set_attach_to_screen_rect(Rect2(offset, size * scale))
	_viewport.set_size_override(true, size)
	_viewport.set_size_override_stretch(true)
	
	offset.x = max(0, offset.x)
	offset.y = max(0, offset.y)

	_container.rect_position.x = offset.x
	_container.rect_position.y = offset.y

	_background.color = background_color
	_background.rect_size = new_window_size
