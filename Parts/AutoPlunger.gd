extends Area2D

func _on_AutoPlunger_body_entered(body):
	get_tree().call_group("Ball","PulsedAutoPlunger")
	get_tree().call_group("Level","CloseOutlineBlocker",name) #passiamo il nome del AP colpito
	$LaunchedSound.play()
