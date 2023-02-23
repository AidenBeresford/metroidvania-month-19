extends Camera2D

onready var player = get_parent().get_node("Player").get_node("Body")

export var minClampX : float
export var minClampY : float
export var maxClampX : float
export var maxClampY : float

func _ready():
	current = true


func _physics_process(delta):
	
	_move_cam()


func _move_cam():
	
	position.x = lerp(position.x, player.global_position.x, .20)
	position.y = lerp(position.y, player.global_position.y, .20)
	
	position.x = clamp(global_position.x, minClampX, maxClampX)
	position.y = clamp(global_position.y, minClampY, maxClampY)
	
