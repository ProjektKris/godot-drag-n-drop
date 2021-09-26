extends RigidBody2D

signal dragsignal
var dragging = false
# dont set this too low or the object will be late and 
export var drag_velocity_multiplier = 16

# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("input_event", self, "_on_input_event")
	connect("dragsignal", self, "_on_dragging")
	pass # Replace with function body.

func _process(_delta):
	if dragging:
		var target_position = get_viewport().get_mouse_position()
		var lv = (target_position - self.position) * drag_velocity_multiplier
		self.linear_velocity = lv
		if Input.is_action_just_released("drag"): # reqires drag input map
			dragging = false
	pass

func _on_dragging():
	dragging = true #!dragging

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			emit_signal("dragsignal")
	elif event is InputEventScreenTouch:
		if event.pressed and event.get_index() == 0:
			emit_signal("dragsignal")
