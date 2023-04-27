extends RigidBody2D

onready var sprite = $Sprite
onready var timer = get_parent().get_node("Timer")

onready var ball_name
onready var new_bump = -1
onready var new_hitsling = -1
onready var new_stateAP = false #AutoPlunger
onready var new_ball = false #per tener conto delle palle perse

export var max_speed = 3000 #velocità massima della pallina. La limiteremo con "clamp"

onready var distance = 0
onready var bounce_direction = 0


func _ready():
	gravity_scale = 10 #setto di meno all'inizio

func _process(delta):
	sprite.set_rotation(-get_rotation()) #per non farla ruotare


func _integrate_forces(state):
	if Input.is_action_just_pressed("restart_ball") or new_ball == true:  #DEBUG
		state.transform = Transform2D(0.0,Vector2(550,1000))
		linear_velocity = Vector2.ZERO
		gravity_scale = 10
		new_ball = false
	
	linear_velocity.x = clamp(linear_velocity.x,-max_speed,max_speed) #prima dell'impatto, riduco la velocita a "max_speed"
	linear_velocity.y = clamp(linear_velocity.y,-max_speed,max_speed) 
	
	
	if new_bump > 0:
		state.apply_central_impulse(new_bump*bounce_direction*max_speed)
		new_bump = -1
	
	if new_hitsling > 0:
		state.apply_central_impulse(new_hitsling*bounce_direction*max_speed)
		new_hitsling = -1
	
	if new_stateAP == true:
		state.apply_central_impulse(bounce_direction*max_speed)
		new_stateAP = false


#Il valore di bump è passato dal bumper. Con -1 indichiamo che non è avvenuto un bump
#se è avvenuto un bump allora aggiornaimo il valore di new_bump, e controlliamo se > 0
#sappiamo che new_bump in tal caso è > 0, quindi applichiamo l'impulso e riportiamo new_bump a -1

func Bumped(bump_value, bumper_position):
	new_bump = bump_value
	distance = bumper_position - global_position #ottengo la distanza fra il centro della palla e del bumper
	bounce_direction = -distance.normalized()    #normalizzo così ottengo il versore, che indica la direzione dove la palla deve rimbalzare.
	
	#Visto che la palla deve rimbalzare in direzione opposta, neghiamo il valore di distance.normalized()
	#E' come se il centro del bumper fosse il centro del cerchio, e la palla un punto sulla circonferenza


func HitSlingshot(sling_value, sling_bounce):
	new_hitsling = sling_value
	bounce_direction = sling_bounce.normalized()
	
	#Il rimbalzo è già stato calcolato in Slingshot.gd, per questo motivo qui non "neghiamo" sling_bounce


func PulsedAutoPlunger():
	new_stateAP = true
	bounce_direction = Vector2.UP



func _on_ResetGravity_body_entered(body):
	gravity_scale = 25


func _on_FallenBall_body_entered(body):
	timer.set_wait_time(2)
	timer.start()

func _on_Timer_timeout():
	new_ball = true
