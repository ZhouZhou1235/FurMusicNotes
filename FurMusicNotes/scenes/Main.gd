# 游戏主循环
# 此处为根树 游戏从此开始运行

extends Node

var fullScreen = false

# 游戏开始
func gameBegin():
	if $Begin.begin:
		$Begin.set_process(false)
		$Begin.hide()
		$Play.set_process(true)
		$Play.show()
		$Play.setPlayState(GArea.musicList[$Begin.selectNum])
		$Play.startingPace()
		$Play.updateCountPanel()

# 游戏结束
func gameEnd():
	$Play.clearPlayState()
	$Play.set_process(false)
	$Play.hide()
	$Begin.set_process(true)
	$Begin.show()
	GArea.playing = false

# 评分并保存当前曲子的游玩记录
func saveTheMusicCount():
	var hitCount = $Play.hitCount
	var title = $Play.itemDict["title"]
	var result = GArea.findTheMusicFromList(title)
	var theItem :Dictionary = result[0]
	var index = result[1]
	var packageIndex = GArea.findThePackageFromList(GArea.musicPackage["package"])[1]
	var star = 0
	var score = 0
	var noteNum = hitCount["best"]+hitCount["great"]+hitCount["good"]+hitCount["ok"]+hitCount["miss"]
	if float(hitCount["best"])/noteNum>0.25: star+=1
	if float(hitCount["ok"])/noteNum<0.25: star+=1
	if hitCount["miss"]==0: star+=1
	if float(hitCount["miss"])/noteNum>0.25: star=0
	score = hitCount["best"]*4+hitCount["great"]*3+hitCount["good"]*2+hitCount["ok"]*1-hitCount["miss"]*4
	if score<0: score=0
	theItem["hitCount"] = hitCount
	theItem["star"] = star
	theItem["score"] = score
	GArea.user["packages"][packageIndex]["musicList"][index] = theItem
	GArea.saveToFile(GArea.userPath,GArea.jsonEncode(GArea.user))

func _ready():
	print("Main ok")

func _input(_event):
	if Input.is_action_just_released("fullScreen"):
		fullScreen = !fullScreen
		if fullScreen:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _on_start_button_down():
	$Begin/Hall.stop()
	gameBegin()

func _on_music_finished():
	saveTheMusicCount()
	$Begin.loadMusicPreview($Begin.selectNum)
	gameEnd()
	$Begin/Hall.play()
	
func _on_end_btn_pressed():
	$Play/Music.stop()
	$PauseOption.continueGame()
	$Begin.loadMusicPreview($Begin.selectNum)
	gameEnd()
	$Begin/Hall.play()

