# 暂停选项
# 使游戏进程函数暂停调用

extends CanvasLayer

var pause :bool = false

# 暂停游戏
func pauseGame():
	$Animate.play("pause")
	get_tree().paused = true
	self.show()

# 继续游戏
func continueGame():
	get_tree().paused = false
	self.hide()

func _input(_event):
	if GArea.playing:
		if Input.is_action_just_pressed("ui_cancel"):
			pause = !pause
			if pause: pauseGame()
			else: continueGame()

func _ready():
	self.hide()

func _on_continue_btn_pressed():
	pause = false
	continueGame()
