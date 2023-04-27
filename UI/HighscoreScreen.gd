extends Control

onready var nodeScore = $Scores
onready var scoreLabel = preload("res://UI/ScoreLabel.tscn")

func _ready():
	if OS.get_name() == "Windows":
		$Menu/ReturnButton.grab_focus()
	
	for button in $Menu.get_children():
		button.connect("pressed",self,"_on_Button_pressed", [button.scene_to_load])
	
	var scores = SavedScores.LoadScores()
	for i in 10:
		var newLabel = scoreLabel.instance()
		newLabel.get_node("id").text = str(i+1)
		newLabel.get_node("name").text = scores[i].name
		newLabel.get_node("score").text = Global.str_with_dots(scores[i].score)
		nodeScore.add_child(newLabel)

func _on_Button_pressed(scene_to_load):
	if(scene_to_load == ""):
		get_tree().quit()
	get_tree().change_scene(scene_to_load)
