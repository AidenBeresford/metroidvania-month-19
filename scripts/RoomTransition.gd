extends Area2D

export var transition_scene : String


func _on_Transition_body_entered(body):
	
	for bodies in get_overlapping_bodies():
		
		if bodies.get_parent().name == "Player":
			transition(transition_scene)


func transition(scene):
		
		room.last_room = get_parent().name
		
		get_tree().change_scene(scene)
		
