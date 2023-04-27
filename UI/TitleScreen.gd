extends Control

func _ready():
	if OS.get_name() == "Windows":
		$Menu/NewGameButton.grab_focus()
	
	for button in $Menu.get_children():
		button.connect("pressed",self,"_on_Button_pressed", [button.scene_to_load])

func _on_Button_pressed(scene_to_load):
	if(scene_to_load == ""):
		get_tree().quit()
	get_tree().change_scene(scene_to_load)
