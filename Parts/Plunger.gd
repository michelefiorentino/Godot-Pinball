extends KinematicBody2D

onready var start_position = global_position

func _physics_process(delta):
	if Input.is_action_pressed("ui_down"):
		move_and_collide(Vector2.DOWN*delta*500)
	else:
		if global_position.y > start_position.y:
			move_and_collide(Vector2.UP*delta*3000)
			if !($LaunchedSound).is_playing():
				$LaunchedSound.play()
