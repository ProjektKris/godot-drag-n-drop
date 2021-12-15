extends Area2D

# true if the current node is being dragged
var dragging := false

# emits when the current node starts or stops being dragged
signal dragsignal

# Called when the node enters the scene tree for the first time.
func _ready():
	if !is_connected("dragsignal", self, "_set_drag_pc"):
		var err_code := connect("dragsignal", self, "_set_drag_pc")
		if err_code != 0:
			print("ERROR: ", err_code)
	if !self.is_connected("input_event", self, "_on_KinematicBody2D_input_event"):
		var err_code := self.connect("input_event", self, "_on_KinematicBody2D_input_event")
		if err_code != 0:
			print("ERROR: ", err_code)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if dragging:
		var mousepos = get_viewport().get_mouse_position()
		self.position = Vector2(mousepos.x, mousepos.y)
		if Input.is_action_just_released("drag"): # reqires drag input map
			dragging = false
	pass

func _set_drag_pc():
	dragging = true

func _on_KinematicBody2D_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			emit_signal("dragsignal")
		elif event.button_index == BUTTON_LEFT and !event.pressed:
			emit_signal("dragsignal")
	elif event is InputEventScreenTouch:
		if event.pressed and event.get_index() == 0:
			self.position = event.get_position()
		
