extends Node2D

func _on_Left_pressed():
	Input.action_press("ui_left")
func _on_Left_released():
	Input.action_release("ui_left")
	

func _on_Right_pressed():
	Input.action_press("ui_right")
func _on_Right_released():
	Input.action_release("ui_right")


func _on_PullPlunger_pressed():
	Input.action_press("ui_down")
func _on_PullPlunger_released():
	Input.action_release("ui_down")
