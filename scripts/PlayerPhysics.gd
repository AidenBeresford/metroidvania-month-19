extends KinematicBody2D

var velocity = Vector2()

const SPD = 180


func _physics_process(delta):
	move_player()
	
	move_and_slide(velocity)


func move_player():
	
	if Input.is_action_pressed("right"):
		velocity.x = lerp(velocity.x, SPD, .20)
	elif Input.is_action_pressed("left"):
		velocity.x = lerp(velocity.x, -SPD, .20)
	else:
		velocity.x = lerp(velocity.x, 0, .20)
