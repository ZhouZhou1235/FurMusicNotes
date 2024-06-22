extends Control

var welcome = true
var willExit = false

func _ready():
	$welcome.visible = true
	$menu.visible = false

func _input(event):
	if welcome:
		if Input.is_action_just_pressed("exitGame"):
				willExit = !willExit
				$exitGame.visible = willExit
		if Input.is_action_just_pressed("ui_accept") or Input.is_key_pressed(KEY_D) or Input.is_action_just_pressed("ui_right"):
				if willExit:
					get_tree().quit()
				else:
					welcome = false
					willExit = false
					$menu.visible = true
					$menu.select = true

func _on_main_music_finished():
	$mainMusic.play()
