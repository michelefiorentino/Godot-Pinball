extends Control

onready var display = $UI_UP/Label
onready var EnterName = $GameoverOverlay/ScoreMenu/LineEdit
onready var loadedScores = SavedScores.LoadScores() #carico gli score
onready var DefaultName = SavedScores.LoadDefaultName()
onready var playerIndex
onready var is_pause_enabled = true

func UpdateText(newText):
	display.text = newText

func _ready():
	if OS.get_name() == "Windows":
		$PauseOverlay/Menu/ResumeButton.grab_focus()
		
	for button in $PauseOverlay/Menu.get_children(): #connetto i pulsanti della pausa
		button.connect("pressed",self,"_on_Button_pressed", [button.scene_to_load])
	
	for button in $GameoverOverlay/Menu.get_children(): #connetto i pulsanti del GameOver
		button.connect("pressed",self,"_on_Button_pressed", [button.scene_to_load])

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel") and is_pause_enabled:
		OpenPauseMenu()

func _notification(what):
	if(what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST) and is_pause_enabled:
		OpenPauseMenu()

func OpenPauseMenu():
	get_tree().paused = !get_tree().paused
	get_tree().call_group("Level","TogglePause")

func OpenGameoverMenu():
	get_tree().paused = !get_tree().paused
	get_tree().call_group("Level","ToggleGameover")

func TogglePause():
	$PauseOverlay.visible = !($PauseOverlay.visible)

func ToggleGameover(score):
	is_pause_enabled = false
	EnterName.text = DefaultName
	
	$GameoverOverlay.visible = !($GameoverOverlay.visible)
	$GameoverOverlay/ScoreMenu/Points.text = Global.str_with_dots(score)
	
	var is_score_updated = false
	var playerName = EnterName.text
	playerIndex
	
	if score > loadedScores[9].score: #è almeno più grande di quello in ultima posizione
		is_score_updated = true
		loadedScores[9].score = score #settiamo il punteggio del giocatore
		loadedScores[9].name =  playerName #settiamo il nome del giocatore (preimpostato)
		var temp
		for i in range (8,-1,-1): #loop al contrario per riordinare i punteggi
			if loadedScores[i+1].score > loadedScores[i].score:
				temp = loadedScores[i+1]
				loadedScores[i+1]= loadedScores[i]
				loadedScores[i]= temp
		
		#individuo l'indice. No, non è una soluzione efficiente
		for i in 10:
			if playerName == loadedScores[i].name and score == loadedScores[i].score:
				playerIndex = i
		
		#mostro a schermo la posizione
		var suffix 
		match playerIndex:
			0:
				suffix = "st"
			1:
				suffix = "nd"
			2:
				suffix = "rd"
			_:
				suffix = "th"
		$GameoverOverlay/ScoreMenu/NewRecordMex.text = "New Record! You're " + str(playerIndex+1) + suffix + "!\nInsert name: "
		
		SavedScores.SaveScore(loadedScores) #aggiunto il player nella giusta posizione, passiamo la lista aggiornata
	
	if is_score_updated:
		$GameoverOverlay/ScoreMenu/NewRecordMex.visible = true
		EnterName.visible = true

func _on_Button_pressed(scene_to_load):
	match scene_to_load:
		"Resume":
			get_tree().paused = !get_tree().paused
			get_tree().call_group("Level","TogglePause")
		"":
			get_tree().quit()
		_:
			get_tree().paused = !get_tree().paused
			get_tree().change_scene(scene_to_load)

#salviamo i dati e il nome di default ad ogni cambiamento del testo
func _on_LineEdit_text_changed(new_text):
	if !(EnterName.text.empty()):
		loadedScores[playerIndex].name = EnterName.text
		SavedScores.SaveScore(loadedScores)
		SavedScores.SaveDefaultName(EnterName.text)
