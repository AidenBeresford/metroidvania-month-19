extends Area2D


func _ready():
	get_parent().get_node("AnimationPlayer").play("Idle")


func _process(delta):
	
	for collisions in get_overlapping_bodies():
		
		if collisions.get_parent().name == "Player":
			
			if Input.is_action_just_pressed("up"):
				
				get_parent().get_node("AnimationPlayer").play("Saving")


func save_game():
	var save_dict = {
		"room" : get_parent().get_parent().get_path(),
		"maxhp" : player.maxhp,
		"hp" : player.hp,
		"items" : player.current_items,
		"last_room" : room.last_room
	}
