extends KinematicBody2D

enum STATE {IDLE, WALK, DASH, JUMP, HOVER, FALL, DEATH}
enum DIR {LEFT, RIGHT}

onready var anim_tree = get_node("AnimationTree")
onready var playback = anim_tree.get("parameters/playback")

var velocity = Vector2()
var state = STATE
var dir = DIR.RIGHT
var dirval = 1

const SPD = 180
const DSH = 1.5
const JMP = -700
const GRV = 20


func _physics_process(delta):
	
	state_manager()
	
	# player abilities based on state
	match state:
		
		STATE.IDLE:
			playback.travel("Idle")
			
			turn()
			walk()
			jump()
		
		STATE.WALK:
			playback.travel("Walk")
			
			turn()
			walk()
			jump()
		
		STATE.DASH:
			playback.travel("Dash")
			
			if !is_on_floor():
				velocity.y += GRV
			
			jump()
			dash()
		
		STATE.JUMP:
			playback.travel("Jump")
			
			velocity.y += GRV
			turn()
			walk()
		
		STATE.HOVER:
			playback.travel("Hover")
			
			velocity.y += GRV
			turn()
			walk()
		
		STATE.FALL:
			playback.travel("Fall")
			
			velocity.y += GRV
			turn()
			walk()
		
		STATE.DEATH:
			pass
	
	move_and_slide(velocity, Vector2.UP)


func state_manager():
	
	if is_on_floor():
		
		velocity.y = 0
		
		if Input.is_action_pressed("dash"):
			state = STATE.DASH
		else:
			if absround(velocity.x) < 10:
				state = STATE.IDLE
			else:
				state = STATE.WALK
	else:
		
		if !Input.is_action_pressed("dash"):
			if velocity.y <= 40 and velocity.y >= -40:
				state = STATE.HOVER
			elif velocity.y < 10:
				state = STATE.JUMP
			elif velocity.y > 10:
				state = STATE.FALL


func turn():
	
	if Input.is_action_pressed("right"):
		$Sprite.flip_h = false
		dir = DIR.RIGHT
		dirval = 1
	elif Input.is_action_pressed("left"):
		$Sprite.flip_h = true
		dir = DIR.LEFT
		dirval = -1


func walk():
	
	# walk command for idle and walk states
	if Input.is_action_pressed("right"):
		velocity.x = lerp(velocity.x, SPD, .20)
	elif Input.is_action_pressed("left"):
		velocity.x = lerp(velocity.x, -SPD, .20)
	else:
		velocity.x = lerp(velocity.x, 0, .20)


func jump():
	
	# jump command for idle and walk states
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = JMP

func dash():
	velocity.x = SPD*DSH*dirval


func absround(num):
	return abs(round(num))
