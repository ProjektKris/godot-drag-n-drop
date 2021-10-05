extends RigidBody2D

# emits when the current node starts being dragged
signal dragsignal

# true if the current node is being dragged
var dragging := false

# dont set this too low or the object will be late behind the mouse 
export var drag_velocity_multiplier := 16

# Called when the node enters the scene tree for the first time.
func _ready():
	if !self.is_connected("input_event", self, "_on_input_event"):
		var err_code := self.connect("input_event", self, "_on_input_event")
		if err_code != 0:
			print("ERROR: ", err_code)
	if !is_connected("dragsignal", self, "_on_dragging"):
		var err_code := connect("dragsignal", self, "_on_dragging")
		if err_code != 0:
			print("ERROR: ", err_code)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
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

func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			emit_signal("dragsignal")
	elif event is InputEventScreenTouch:
		if event.pressed and event.get_index() == 0:
			emit_signal("dragsignal")
