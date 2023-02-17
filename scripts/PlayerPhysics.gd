extends KinematicBody2D

enum STATE {IDLE, WALK, DASH, JUMP, FALL, DEATH}
enum DIR {LEFT, RIGHT, DOWN, UP}

var velocity = Vector2()
var state = STATE

const SPD = 180
const JMP = -300


func _physics_process(delta):
	walk()
	jump()
	
	velocity.y -= 10
	
	move_and_slide(velocity)


func walk():
	
	if Input.is_action_pressed("right"):
		velocity.x = lerp(velocity.x, SPD, .20)
	elif Input.is_action_pressed("left"):
		velocity.x = lerp(velocity.x, -SPD, .20)
	else:
		velocity.x = lerp(velocity.x, 0, .20)


func jump():
	
	if Input.is_action_pressed("jump"):
		velocity.y = JMP
	
