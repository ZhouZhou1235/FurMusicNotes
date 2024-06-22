extends Control

var pause = false
var gameEnd = false

func _ready():
	self.visible = pause

func _input(event):
	if !gameEnd:
		if Input.is_action_just_pressed("ui_cancel"):
			pause = !pause
			$hitBack.play()
		if pause:
			if Input.is_key_pressed(KEY_R):
				gameEnd = true
				$hitBack.play()
	else:
		if Input.is_action_just_pressed("ui_accept"):
			get_tree().paused = false
			$hitBack.play()
		
func _process(delta):
	if !gameEnd:
		self.visible = pause
		get_tree().paused = pause

func _on_hit_back_finished():
	if gameEnd:
		get_tree().paused = false
		$successMusic.stop()
		$failedMusic.stop()
		get_tree().change_scene_to_file("res://scenes/main.tscn")
