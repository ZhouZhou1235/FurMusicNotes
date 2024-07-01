extends Node2D

var noteList :Array
var noteListIndex = 0
var listLength :int
var hitBox = load("res://scenes/hitBox.tscn")
var advanceTime
var musicTime = 0

var gameScore = 60
var missNote = 0
var difficulty = GlobalArea.difficulty

var begin = false

func musicIntro():
	$intro/introAnimation.play("intro")
	$intro/readyToGo.play()
	await get_tree().create_timer(1.2,false).timeout
	$intro/countdown.text = "开始演奏！"
	print("PINKCANDY "+GlobalArea.musicName+" 即将开始演奏")

func musicBegin():
	$music.play()
	$videoBackground.play()
	print("PINKCANDY "+GlobalArea.musicName+" 开始")

func noteRunning():
	musicTime = $music.get_playback_position()+AudioServer.get_time_since_last_mix()
	musicTime -= AudioServer.get_output_latency()
	if noteListIndex<listLength:
		if musicTime>noteList[noteListIndex][1]:
			for i in noteList[noteListIndex][0]:
				if i==0:continue
				var theBox = hitBox.instantiate()
				var screen = get_viewport_rect()
				theBox.position.x = 64 + 128*i
				theBox.position.y = screen.position.y
				theBox.hitBoxSpeed = GlobalArea.hitBoxSpeed
				theBox.key = i
				add_child(theBox)
			noteListIndex += 1

func gameOver(score):
	if score<=0:
		for i in get_children():
			if i is AudioStreamPlayer:i.stop()
			else:i.hide()
		$endGame.color = Color(0,0,0,1)
		$endGame.show()
		$role.show()
		$role.animation = "failed"
		$role.play()
		$stopGame/failed.play()
		$endGame/result.add_theme_color_override("font_color", Color(200,200,200))
		$endGame/gameScore.add_theme_color_override("font_color", Color(200,200,200))
		$endGame/missNote.add_theme_color_override("font_color", Color(200,200,200))
		$endGame/difficulty.add_theme_color_override("font_color", Color(200,200,200))
		$endGame/result.text = GlobalArea.musicName+" 搞砸了！"
		$endGame/gameScore.text = "分数 0"
		$endGame/missNote.text = "漏音 "+str(missNote)
		if difficulty==1:$endGame/difficulty.text = "简单模式"
		elif difficulty==2:$endGame/difficulty.text = "正常模式"
		elif difficulty==3:$endGame/difficulty.text = "困难模式"
		elif difficulty==4:
			$endGame/missNote.text = "漏音 -"
			$endGame/difficulty.text = "严格模式"
		$levelEnd.show()
		GlobalArea.levelPlay = false
		var osName = OS.get_name()
		if osName!="Windows" and osName!="Linux":$phoneButton.show()
		print("PINKCANDY 游戏失败")

func gameSuccess():
	for i in get_children():
		if i is AudioStreamPlayer:pass
		else:i.hide()
	$endGame.color = Color(200,200,200,1)
	$endGame.show()
	$role.show()
	$role.animation = "success"
	$role.play()
	$stopGame/success.play()
	$endGame/result.text = GlobalArea.musicName+" 过关！"
	if missNote>40:
		$endGame/gameScore.text = "分数 "+str(gameScore-40)
	else:
		$endGame/gameScore.text = "分数 "+str(gameScore-missNote)
	$endGame/missNote.text = "漏音 "+str(missNote)
	if difficulty==1:$endGame/difficulty.text = "简单模式"
	elif difficulty==2:$endGame/difficulty.text = "正常模式"
	elif difficulty==3:$endGame/difficulty.text = "困难模式"
	elif difficulty==4:
		$endGame/gameScore.text = "分数 -"
		$endGame/missNote.text = "漏音 -"
		$endGame/difficulty.add_theme_color_override("font_color", Color(200,0,0))
		$endGame/difficulty.text = "严格模式"
	$levelEnd.show()
	GlobalArea.levelPlay = false
	print("PINKCANDY 过关")

func levelInput():
	if GlobalArea.levelPlay:
		if Input.is_action_just_pressed("hit1"):
			$role.animation = "hit12"
			$line/theLine/theLineAnimation.play("hit1")
		if Input.is_action_just_pressed("hit2"):
			$role.animation = "hit12"
			$line/theLine/theLineAnimation.play("hit2")
		if Input.is_action_just_pressed("hit3"):
			$role.animation = "hit34"
			$line/theLine/theLineAnimation.play("hit3")
		if Input.is_action_just_pressed("hit4"):
			$role.animation = "hit34"
			$line/theLine/theLineAnimation.play("hit4")
		if Input.is_action_just_pressed("hit5"):
			$role.animation = "hit56"
			$line/theLine/theLineAnimation.play("hit5")
		if Input.is_action_just_pressed("hit6"):
			$role.animation = "hit56"
			$line/theLine/theLineAnimation.play("hit6")
		if Input.is_action_just_pressed("hit7"):
			$role.animation = "hit78"
			$line/theLine/theLineAnimation.play("hit7")
		if Input.is_action_just_pressed("hit8"):
			$role.animation = "hit78"
			$line/theLine/theLineAnimation.play("hit8")
		$role.play()
	else:
		if Input.is_action_just_pressed("ui_accept") or GlobalArea.button_enter:
			$levelEnd/levelEndAnimation.play("backToMain")

func _ready():
	var osName = OS.get_name()
	if osName!="Windows" and osName!="Linux":$phoneButton.show()
	$music.stream = load(GlobalArea.musicSrc)
	$videoBackground.stream = load(GlobalArea.videoBackgroundSrc)
	$background.texture = load(GlobalArea.backgroundSrc)
	$decoration.sprite_frames = load(GlobalArea.decorationSrc)
	$role.sprite_frames = load(GlobalArea.roleSrc)
	noteList = GlobalArea.noteList
	listLength = len(noteList)
	advanceTime = 640/(GlobalArea.hitBoxSpeed*0.1667)
	if difficulty==4:gameScore=100
	$musicInfo/info.text = "当前曲目 "+GlobalArea.musicName+" "+GlobalArea.worker
	if difficulty==1:$musicInfo/mode.text="简单模式"
	elif difficulty==2:$musicInfo/mode.text="正常模式"
	elif difficulty==3:$musicInfo/mode.text="困难模式"
	elif difficulty==4:
		$musicInfo/mode.add_theme_color_override("font_color",Color(250,0,0))
		$musicInfo/mode.text="严格模式"
	$lifeBar.value = gameScore
	$role.play()
	$decoration.play()
	print("PINKCANDY "+GlobalArea.musicName+" 关卡资源载入完成")
	musicIntro()

func _process(delta):
	if begin:
		noteRunning()
		$lifeBar.value = gameScore

func _unhandled_input(event):
	levelInput()

func _on_line_body_entered(body):
	body.canHit = true

func _on_line_body_exited(body):
	body.canHit = false
	if body.hited:
		if difficulty==4:pass
		else:gameScore += 1
		if gameScore>100:gameScore=100
	else:
		if difficulty==1:gameScore -= 5
		elif difficulty==2:gameScore -= 10
		elif difficulty==3:gameScore -= 20
		elif difficulty==4:gameScore -= 10
		missNote += 1
		$role.animation = "sad"
		$role.play()
		gameOver(gameScore)

func _on_role_animation_finished():
	$role.animation = "default"
	$role.play()

func _on_stop_game_hidden():
	if $stopGame.endGame:
		$music.stop()
		GlobalArea.welcome = true
		GlobalArea.levelPlay = false
		$levelEnd/levelEndAnimation.play("backToMain")

func _on_music_finished():
	gameSuccess()

func _on_stop_game_visibility_changed():
	if Input.is_action_just_pressed("ui_cancel"):
		$stopGame/down.play()

func _on_level_end_animation_animation_finished(anim_name):
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main.tscn")
	print("PINKCANDY 返回欢迎舞台")

func _on_exact_line_body_entered(body):
	if body.hited:
		body.hitBoxSpeed = 0
		if difficulty==4:pass
		else:gameScore += 1
		if gameScore>100:gameScore=100
		body.exactShow()

func _on_ready_to_go_finished():
	musicBegin()
	begin = true
	print("PINKCANDY 音乐时钟开始运转")

func _on_button_enter_button_down():
	GlobalArea.button_enter = true
	levelInput()
	GlobalArea.button_enter = false
