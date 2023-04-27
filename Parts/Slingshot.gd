extends StaticBody2D

export var sling_value: float = 2
onready var C = 0 #rappresenterà il vettore fra i due punti A e B della SlingArea
onready var anim = $AnimationPlayer

func _ready():
	var A = $SlingArea/CollisionSling.shape.a
	var B = $SlingArea/CollisionSling.shape.b
	C = A-B #vettore che va da A a B, centrato nell'origine
	
	#verifico se si tratta dello Slinshot di SX o DX. Cerchiamo di capire in quale metà di campo si trova
	if ( get_viewport_rect().size.x/2 > global_position.x ): #significa che si tratta di SlingShot SX, quindi invertiamo la x di C per il rimbalzo
		C.x = -C.x

func _on_SlingArea_body_entered(body):
	anim.play("Sling")
	get_tree().call_group("Ball","HitSlingshot",sling_value,C)
	get_tree().call_group("Level","UpdateScore",1000)
	$SlingSound.play()
