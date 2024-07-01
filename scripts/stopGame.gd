extends CenterContainer

var stopGame = false
var endGame = false

func _ready():
	self.visible = false

func _input(event):
	if GlobalArea.levelPlay:
		if Input.is_action_just_pressed("ui_cancel"):
			stopGame = !stopGame
			get_tree().paused = stopGame
			self.visible = stopGame
			print("PINKCANDY 触发了暂停逻辑")
		if stopGame:
			if Input.is_action_just_pressed("ui_accept"):
				endGame = true
				self.hide()
