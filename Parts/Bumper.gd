extends Area2D

#4 sembra un valore adeguato.
#1 darebbe la forza necessaria a fermare la palla
#2 respinge la palla in direzione opposta con la stessa forza (nb: tieni poi anche conto della gravità)

export var bump_value: float = 4
onready var anim = $AnimationPlayer

func _on_Bumper_body_entered(body):
	anim.play("Lighten")
	get_tree().call_group("Ball","Bumped",bump_value,global_position)
	get_tree().call_group("Level","UpdateScore",1500)
	$BumperSound.play()
