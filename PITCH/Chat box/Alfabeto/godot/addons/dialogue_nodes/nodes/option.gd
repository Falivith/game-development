tool
extends HBoxContainer

signal text_changed(new_text)
signal text_entered(new_text)

onready var line_edit = $LineEdit
onready var filter_button = $FilterButton
onready var filter_panel = $FilterPanel
onready var value1 = $FilterPanel/HBoxContainer/Value1
onready var operator = $FilterPanel/HBoxContainer/Operator
onready var value2 = $FilterPanel/HBoxContainer/Value2
onready var reset_button = $FilterPanel/HBoxContainer/ResetButton

var text = ''
var placeholder_text = ''
var filter_popup_offset := 0


func set_text(value):
	line_edit.text = value
	filter_button.visible = value != ''
	text = value


func set_placeholder_text(value):
	placeholder_text = value
	line_edit.placeholder_text = value


func get_condition():
	var dict = {}
	
	if operator.selected > -1:
		dict['value1'] = value1.text
		dict['operator'] = operator.selected
		dict['value2'] = value2.text
	
	return dict


func set_condition(new_condition: Dictionary):
	if new_condition.empty():
		value1.text = ''
		operator.selected = -1
		value2.text = ''
	else:
		value1.text = new_condition['value1']
		operator.selected = new_condition['operator']
		value2.text = new_condition['value2']
	_on_condition_changed()


func _on_filter_button_pressed():
	var popup_pos = rect_global_position + filter_button.rect_position + Vector2(0, rect_size.y + filter_popup_offset)
	filter_panel.popup(Rect2(popup_pos, filter_panel.rect_size))


func _on_text_changed(new_text):
	filter_button.visible = new_text != ''
	text = new_text
	emit_signal("text_changed", new_text)


func _on_text_submitted(new_text):
	filter_button.visible = new_text != ''
	text = new_text
	emit_signal("text_entered", new_text)


func _on_condition_changed(_a= 0):
	emit_signal("text_changed", text)
	if value1.text == '' and operator.selected == -1 and value2.text == '':
		reset_button.hide()
		filter_button.text = ''
		return
	
	filter_button.text = '*'
	reset_button.show()


func _on_condition_reset():
	value1.text = ''
	operator.selected = -1
	value2.text = ''
	filter_button.text = ''
	reset_button.hide()
	emit_signal("text_changed", text)


func _on_text_focus_exited():
	emit_signal("focus_exited")
