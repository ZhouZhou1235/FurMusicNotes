# 游戏视图
# 游戏画面根结点 所有元素都在此节点下

extends Node2D

var itemDict :Dictionary
var notedata :Dictionary
var noteList :Array
var musicTime :float
var noteListIndex :int
var note :Resource
var music :Resource
var hitCount :Dictionary

# 初始化
func init():
	self.set_process(false)
	self.hide()
	musicTime = 0
	noteListIndex = 0
	note = load("res://scenes/Note.tscn")
	hitCount = {
		"best":0,
		"great":0,
		"good":0,
		"ok":0,
		"miss":0,
	}

# 设置关卡状态
func setPlayState(theDict):
	itemDict = theDict
	notedata = GArea.jsonDecodeFromPath(itemDict["notedata"])
	noteList = notedata["notes"]
	music = AudioStreamOggVorbis.load_from_file(itemDict["music"])
	$Music.stream = music
	$MusicInfo.text = itemDict["worker"]+"-"+itemDict["title"]

# 清除关卡状态
func clearPlayState():
	$Music.stop()
	itemDict = {}
	notedata = {}
	noteList = []
	musicTime = 0
	noteListIndex = 0
	music = null
	for i in $Notes.get_child_count():
		$Notes.get_child(i).queue_free()
	hitCount = {
		"best":0,
		"great":0,
		"good":0,
		"ok":0,
		"miss":0,
	}

# 起步节奏
func startingPace():
	$GuideAnimate.stop()
	$StartPace.show()
	var num = 3
	var bpm = notedata["bpm"]
	var beatTime = 60/bpm
	while num>0:
		$StartPace.text = str(num)
		$StartPace/PaceReady.play()
		await self.get_tree().create_timer(beatTime).timeout
		num -= 1
	$StartPace.text = "开始！"
	$StartPace/PaceGo.play()
	await self.get_tree().create_timer(beatTime).timeout
	$StartPace.hide()
	playgame()

# 开始演奏
func playgame():
	musicTime = 0
	noteListIndex = 0
	GArea.playing = true
	$Music.play()
	$GuideAnimate.play("guide")

# 显示轨道引导
func showGuide():
	if !$GuideAnimate.is_playing(): $GuideAnimate.play("guide")

# 音符节拍落下
func noteRunning():
	musicTime = $Music.get_playback_position()+AudioServer.get_time_since_last_mix()
	musicTime -= AudioServer.get_output_latency()
	if noteListIndex<len(noteList):
		var theNote :Dictionary = noteList[noteListIndex]
		if musicTime>theNote["time"]:
			var theBox = note.instantiate()
			var speed :int = notedata["speed"]
			var key :int = theNote["key"]
			var long :float = theNote["long"]
			var need :bool = theNote["needHit"]
			theBox.setAndGo(speed,key,long,need)
			$Notes.add_child(theBox)
			if theBox.isLong: runlLongNote(speed,key,long,need)
			noteListIndex += 1

# 生成长音符
func runlLongNote(speed,key,long,need):
	var beginTime = musicTime
	var theTimeMove = 0
	while theTimeMove<long and GArea.playing:
		await self.get_tree().create_timer(0.1).timeout
		theTimeMove = musicTime-beginTime
		var longBox = note.instantiate()
		longBox.setAndGo(speed,key,long,need)
		$Notes.add_child(longBox)

# 计分
func addCount(accuracy):
	if accuracy==1:
		hitCount["best"] += 1
		if !$Animate.is_playing(): $Animate.play("hitnote_best")
	elif accuracy==2:
		hitCount["great"] += 1
		if !$Animate.is_playing(): $Animate.play("hitnote_great")
	elif accuracy==3:
		hitCount["good"] += 1
		if !$Animate.is_playing(): $Animate.play("hitnote_good")
	else:
		hitCount["ok"] += 1
		if !$Animate.is_playing(): $Animate.play("hitnote_ok")

# 更新计分面板
func updateCountPanel():
	$CountPanel/HitBest/Num.text = str(hitCount["best"])
	$CountPanel/HitGreat/Num.text = str(hitCount["great"])
	$CountPanel/HitGood/Num.text = str(hitCount["good"])
	$CountPanel/HitOK/Num.text = str(hitCount["ok"])
	$CountPanel/HitMiss/Num.text = str(hitCount["miss"])

# 漏掉音符
func missNote():
	hitCount["miss"] += 1
	$Animate.play("hitnote_miss")

func _process(_delta):
	if GArea.playing:
		noteRunning()
		updateCountPanel()

func _ready():
	self.init()
	print("Play ok")

func _input(_event):
	if Input.is_action_just_pressed("showGuide"):
		showGuide()

func _on_judgment_area_body_entered(body):
	if body.needHit:
		body.canHit = true
	else:
		body.hitNote()

func _on_judgment_area_body_exited(body):
	body.canHit = false
	if !body.hit and body.needHit: missNote()
