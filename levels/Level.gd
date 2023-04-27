extends Node

onready var TouchControls = $SmartphoneControl
onready var are_tc_enabled = true

onready var ball = $Balls/Ball
onready var timer = $Timer
onready var BlockerHit
onready var BlockerDC = Color(0.05,0.05,0.05) #Disabled Color
onready var BlockerEC = Color(0.23,0.23,0.23) #Enabled Color

onready var Lives = 3
onready var Score = 0
onready var Multiplier = 1
onready var is_text_updatable = true #lo usiamo per far in modo che i "messaggi" durino almeno un TOT di tempo

func _ready():
	get_tree().call_group("HUD","UpdateText","Balls: "+str(Lives)+" | Score: 0")
	EnablePlunger()
	$BackgroundMusic.play()



func UpdateMultiplier(newM):
	Multiplier = newM
	is_text_updatable = false
	yield(get_tree().create_timer(2.0), "timeout")
	is_text_updatable = true

func UpdateScore(Points):
	Score += Multiplier*Points
	if is_text_updatable:
		get_tree().call_group("HUD","UpdateText","Balls: "+str(Lives)+" | Score: "+Global.str_with_dots(Score))

func CloseOutlineBlocker(AP_name): #In base a AP_name, selezioniamo il Blocker corretto
	if AP_name == "AutoPlungerSX":
		BlockerHit = $Borders/OutlaneBlockers/OutlineBlockerSX
	else:
		BlockerHit = $Borders/OutlaneBlockers/OutlineBlockerDX
	timer.set_wait_time(0.2)
	timer.start()

#BlockerHit contiene il blocker corretto. Ne disattiviamo la collisione e cambiamo il colore scaduto il timer
func _on_Timer_timeout(): 
	BlockerHit.get_node("CollisionPolygon2D").set_deferred("disabled",false)
	BlockerHit.get_node("Blocker").color = BlockerEC
	timer.stop()

#non solo chiudo, ma cambio anche il tipo di input per il touchscreen
func _on_ClosePlungerLine_body_entered(body): 
	$Borders/OutlaneBlockers/PlungerBlocker.get_node("CollisionPolygon2D").set_deferred("disabled",false)
	$Borders/OutlaneBlockers/PlungerBlocker.get_node("Blocker").color = BlockerEC
	
	EnableFlippers() #la palla in gioco, passo il comando ai flipper

func UnlockOutlineBlockers():
	$Borders/OutlaneBlockers/OutlineBlockerSX.get_node("CollisionPolygon2D").set_deferred("disabled",true)
	$Borders/OutlaneBlockers/OutlineBlockerDX.get_node("CollisionPolygon2D").set_deferred("disabled",true)
	$Borders/OutlaneBlockers/OutlineBlockerSX.get_node("Blocker").color = BlockerDC
	$Borders/OutlaneBlockers/OutlineBlockerDX.get_node("Blocker").color = BlockerDC
	is_text_updatable = false
	yield(get_tree().create_timer(2.0), "timeout")
	is_text_updatable = true

func UnlockAllBlockers():
	UnlockOutlineBlockers()
	$Borders/OutlaneBlockers/PlungerBlocker.get_node("CollisionPolygon2D").set_deferred("disabled",true)
	$Borders/OutlaneBlockers/PlungerBlocker.get_node("Blocker").color = BlockerDC


func _on_FallenBall_body_entered(body):
	UnlockAllBlockers()
	Lives -= 1
	if Lives == 0:
		get_tree().call_group("HUD","UpdateText","GAME OVER")
		get_tree().call_group("HUD","OpenGameoverMenu")
		ball.queue_free()
	else:
		get_tree().call_group("HUD","UpdateText","BALL LOST")
		yield(get_tree().create_timer(2.0), "timeout")
		UpdateScore(0)
	
	EnablePlunger() #la palla è uscita, passo il comando al plunger


func TogglePause():
	are_tc_enabled = !are_tc_enabled
	ToggleTouchControls(are_tc_enabled)
	get_tree().call_group("HUD","TogglePause")

func ToggleGameover(): #presumo che con un po' di coding possa anche non usare questa funzione, ma per il momento la rimango
	are_tc_enabled = !are_tc_enabled
	ToggleTouchControls(are_tc_enabled)
	get_tree().call_group("HUD","ToggleGameover",Score)

func EnableFlippers():
	TouchControls.get_node("Left").visible = true
	TouchControls.get_node("Right").visible = true
	TouchControls.get_node("PullPlunger").visible = false

func EnablePlunger():
	TouchControls.get_node("Left").visible = false
	TouchControls.get_node("Right").visible = false
	TouchControls.get_node("PullPlunger").visible = true

func ToggleTouchControls(state):
	if state == true:
		for tc in TouchControls.get_children():
			tc.visible = true
	else:
		for tc in TouchControls.get_children():
			tc.visible = false
