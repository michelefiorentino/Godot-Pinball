extends "res://Parts/Flipper.gd"

onready var i = 0

func _physics_process(delta):
	if Input.is_action_pressed("ui_right"):
		if rotation_degrees < MAX_ROTATION:
			rotation_degrees+=power*delta
	elif rotation_degrees > MIN_ROTATION:
		rotation_degrees-=power*delta

	if Input.is_action_just_pressed("ui_right"):
		$FlipperSound.play()

	if rotation_degrees <= MIN_ROTATION:
		rotation_degrees = MIN_ROTATION
	elif rotation_degrees >= MAX_ROTATION:
		rotation_degrees = MAX_ROTATION


