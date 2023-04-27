extends Node2D

var ball = preload("res://Parts/Ball.tscn").instance()
onready var anim = $AnimationPlayer

onready var CountLongUpper = 0
onready var CountLongLower = 0
onready var ActiveStars = 0

func _process(delta):
	if CountLongUpper == 3: #attivati tutti i lunghi di sopra, aggiungiamo una stella
		NewStar()
	
	if CountLongLower == 2: #attivati tutti i lunghi di sotto, aggiungiamo una palla
		UnlockOB()



#Segnali per i lunghi di SOPRA

func _on_L1_body_entered(body):
	$Longs/L1/LS1.visible = false #nascondiamo lo sprite "spento"
	$Longs/L1/CollisionShape2D.set_deferred("disabled",true) #disattiviamo il nodo
	CountLongUpper += 1


func _on_L2_body_entered(body):
	$Longs/L2/LS2.visible = false #nascondiamo lo sprite "spento"
	$Longs/L2/CollisionShape2D.set_deferred("disabled",true) #disattiviamo il nodo
	CountLongUpper += 1


func _on_L3_body_entered(body):
	$Longs/L3/LS3.visible = false #nascondiamo lo sprite "spento"
	$Longs/L3/CollisionShape2D.set_deferred("disabled",true) #disattiviamo il nodo
	CountLongUpper += 1


#Nuova stella (o bonus)

func NewStar():
	var multiplier = 6 #settiamo 6, il massimo, di default
	anim.play("Lighten_UPPER")
	$LightsOnSound.play()
	ActiveStars +=1
	CountLongUpper = 0
	match ActiveStars:
		0:
			multiplier = 1
		1:
			$Stars/Sx2.visible = false
			multiplier = 2
			get_tree().call_group("HUD","UpdateText","Multiplier x2!")
		2:
			$Stars/Sx4.visible = false
			multiplier = 4
			get_tree().call_group("HUD","UpdateText","Multiplier x4!")
		3:
			$Stars/Sx6.visible = false
			get_tree().call_group("HUD","UpdateText","Multiplier x6!")
			#moltiplica punteggio X6!
		_:
			get_tree().call_group("Level","UpdateScore",50000)
			get_tree().call_group("HUD","UpdateText","Bonus: 300.000!")
	get_tree().call_group("Level","UpdateMultiplier",multiplier)
	yield(get_tree().create_timer(2.0), "timeout")
	get_tree().call_group("Level","UpdateScore",0) #rimetto il punteggio nel display




#segnali per i lunghi di SOTTO

func _on_L4_body_entered(body):
	$Longs/L4/LS4.visible = false #nascondiamo lo sprite "spento"
	$Longs/L4/CollisionShape2D.set_deferred("disabled",true) #disattiviamo il nodo
	CountLongLower += 1


func _on_L5_body_entered(body):
	$Longs/L5/LS5.visible = false #nascondiamo lo sprite "spento"
	$Longs/L5/CollisionShape2D.set_deferred("disabled",true) #disattiviamo il nodo
	CountLongLower += 1
	

#Nuova Palla

func UnlockOB():
	anim.play("Lighten_LOWER")
	$LightsOnSound.play()
	CountLongLower = 0
	get_tree().call_group("Level","UnlockOutlineBlockers")
	get_tree().call_group("HUD","UpdateText","Outlines opened!")
	yield(get_tree().create_timer(2.0), "timeout")
	get_tree().call_group("Level","UpdateScore",0) #rimetto il punteggio nel display


func _on_FallenBall_body_entered(body):
	ActiveStars = 0
	CountLongUpper = 0
	CountLongLower = 0
	anim.play("restart_lights")
