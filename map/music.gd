extends AudioStreamPlayer


func _ready() -> void:
	Global.music = self

func start_final_sequence() -> void:
	playing = false
	$FinalMusic.playing = true

func fail_stop() -> void:
	$FinalMusic.volume_db = -80
