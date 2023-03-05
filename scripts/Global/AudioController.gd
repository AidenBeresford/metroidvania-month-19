extends Node


func change_audio(path):
	
	if $ASP.stream.get_path() != path:
		
		$ASP.stream = load(path)
		$ASP.play()


func adjust_pitch(pitch):
	
	if $ASP.pitch_scale != pitch:
		
		$ASP.pitch_scale = pitch
