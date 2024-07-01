extends Node

var welcome = true
var levelPlay = false
var selectNum = 0
var musicQuantity = 3 # 歌曲数量 需要爪动更新
var level
var levelGD
var levelScene
var exitGame = false
var fullScreen = false
var difficulty = 2

var musicName
var worker
var musicInfo
var previewSrc
var backgroundSrc
var videoBackgroundSrc
var decorationSrc
var roleSrc
var musicSrc
var noteList
var hitBoxSpeed

func loadLevel(selectNum):
	# 关卡GD脚本载入 需要爪动更新
	if selectNum==1:
		levelGD = load("res://levelResource/furryMusician/furryMusician.gd")
	elif selectNum==2:
		levelGD = load("res://levelResource/cheese_snacks_good/cheese_snacks_good.gd")
	elif selectNum==3:
		levelGD = load("res://levelResource/repairMe/repairMe.gd")
	else:
		musicName = "毛绒音符"
		worker = "Fur Music Notes"
		musicInfo = "
		上下选择 回车开始
		按键说明
		下一步：回车 空格
		选择：上下键 W S
		切换难度：Q
		唤起菜单：ESC
		演奏：ASDFJKL; 或 QWERUIOP
		全屏切换：F11
		"
		previewSrc = "res://assets/preview_unselect.tres"
		showPreview(musicName,worker,musicInfo,previewSrc)
		return
	levelGD = levelGD.new()
	musicName = levelGD.musicName
	worker = levelGD.worker
	musicInfo = levelGD.musicInfo
	previewSrc = levelGD.previewSrc
	backgroundSrc = levelGD.backgroundSrc
	videoBackgroundSrc = levelGD.videoBackgroundSrc
	decorationSrc = levelGD.decorationSrc
	roleSrc = levelGD.roleSrc
	musicSrc = levelGD.musicSrc
	noteList = levelGD.noteList
	hitBoxSpeed = levelGD.hitBoxSpeed
	showPreview(musicName,worker,musicInfo,previewSrc)

func showPreview(musicName,worker,musicInfo,previewSrc):
	$menu/musicName.text = musicName
	$menu/worker.text = worker
	$menu/musicInfo.text = musicInfo
	$menu/preview.sprite_frames = load(previewSrc)
	$menu/preview.play()
	
func levelBegin():
	levelScene = load("res://scenes/level.tscn")
	level = levelScene.instantiate()
	level.show()
	welcome = false
	levelPlay = true
	GlobalArea.welcome = welcome
	GlobalArea.levelPlay = levelPlay
	GlobalArea.musicName = musicName
	GlobalArea.worker = worker
	GlobalArea.musicInfo = musicInfo
	GlobalArea.previewSrc = previewSrc
	GlobalArea.backgroundSrc = backgroundSrc
	GlobalArea.videoBackgroundSrc = videoBackgroundSrc
	GlobalArea.decorationSrc = decorationSrc
	GlobalArea.roleSrc = roleSrc
	GlobalArea.musicSrc = musicSrc
	GlobalArea.noteList = noteList
	GlobalArea.hitBoxSpeed = hitBoxSpeed
	GlobalArea.difficulty = difficulty
	$mainMusic.stop()
	add_child(level)
	print("PINKCANDY 进入关卡 "+GlobalArea.musicName)

func mainInput():
	if welcome:
		if (Input.is_action_just_pressed("ui_accept") or GlobalArea.button_enter) and !exitGame:
			welcome = false
			$CanvasHandoff/handoffAnimation.play("handoff")
			await get_tree().create_timer(0.5,false).timeout
			$menu.show()
		elif (Input.is_action_just_pressed("ui_accept") or GlobalArea.button_enter) and exitGame:
			get_tree().quit()
		if Input.is_action_just_pressed("ui_cancel") or GlobalArea.button_esc:
			exitGame = !exitGame
			$exitGame.visible = exitGame
	else:
		if !GlobalArea.levelPlay:
			if Input.is_action_just_pressed("ui_accept") or GlobalArea.button_enter:
				if selectNum!=0 and !levelPlay:
					$CanvasHandoff/handoffAnimation.play("handoff")
					await get_tree().create_timer(0.5,false).timeout
					levelBegin()
			if Input.is_action_just_pressed("ui_cancel") or GlobalArea.button_esc:
				welcome = true
				$CanvasHandoff/handoffAnimation.play("handoff")
				await get_tree().create_timer(0.5,false).timeout
				$menu.hide()
			if Input.is_action_just_pressed("ui_down") or Input.is_key_label_pressed(KEY_S) or GlobalArea.button_down:
				if selectNum>=musicQuantity:selectNum=musicQuantity
				else:
					$CanvasHandoff/handoffAnimation.play("selectMusic")
					await get_tree().create_timer(0.3,false).timeout
					selectNum += 1
				loadLevel(selectNum)
			if Input.is_action_just_pressed("ui_up") or Input.is_key_label_pressed(KEY_W) or GlobalArea.button_up:
				if selectNum<=0:selectNum=0
				else:
					$CanvasHandoff/handoffAnimation.play("selectMusic")
					await get_tree().create_timer(0.3,false).timeout
					selectNum -= 1
				loadLevel(selectNum)
			if Input.is_key_pressed(KEY_Q) or GlobalArea.button_q:
				if difficulty>=4:
					$menu/difficulty.add_theme_color_override("font_color",Color(0,0,0))
					difficulty=1
				else:difficulty += 1
				GlobalArea.difficulty = difficulty
				if difficulty==1:$menu/difficulty.text="难度 简单"
				elif difficulty==2:$menu/difficulty.text="难度 正常"
				elif difficulty==3:$menu/difficulty.text="难度 困难"
				elif difficulty==4:
					$menu/difficulty.add_theme_color_override("font_color",Color(250,0,0))
					$menu/difficulty.text="难度 严格"
	if Input.is_action_just_released("fullScreen"):
		fullScreen = !fullScreen
		if fullScreen:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _ready():
	var osName = OS.get_name()
	if osName!="Windows" and osName!="Linux":$phoneButton.show()
	$CanvasLogo/logoAnimation.play("recover")
	print("PINKCANDY 游戏主循环加载完成")

func _input(event):
	mainInput()

func _process(delta):
	pass

func _on_main_music_finished():
	$mainMusic.play()

func _on_logo_animation_animation_finished(anim_name):
	$mainMusic.play()
	$CanvasLogo.hide()

func _on_button_esc_button_down():
	GlobalArea.button_esc = true
	mainInput()
	GlobalArea.button_esc = false

func _on_button_enter_button_down():
	GlobalArea.button_enter = true
	mainInput()
	GlobalArea.button_enter = false

func _on_button_up_button_down():
	GlobalArea.button_up = true
	mainInput()
	GlobalArea.button_up = false

func _on_button_down_button_down():
	GlobalArea.button_down = true
	mainInput()
	GlobalArea.button_down = false

func _on_button_q_button_down():
	GlobalArea.button_q = true
	mainInput()
	GlobalArea.button_q = false
