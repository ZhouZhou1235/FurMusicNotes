extends Node2D

var hitBox = load("res://scenes/hitBox.tscn")

# 音符盒
var musicPlay = false
var n4 = 0.416725 # 60/140 - 运行耗时 0.416725
var n2 = n4*2
var n1 = n4*4
var n8 = n4*0.5
var n16 = n4*0.25
var hitBoxList = [
	[[1], [n4]], [[1], [n4]], [[3], [n2]], 
	[[1], [n4]], [[1], [n4]], [[5], [n2]], 
	[[6], [n4]], [[7], [n4]], [[8], [n4]], [[7], [n4]], 
	[[6], [n4]], [[5], [n4]], [[3], [n2]], 
	[[1], [n4]], [[1], [n4]], [[3], [n2]], 
	[[1], [n4]], [[1], [n4]], [[2], [n2]], 
	[[5], [n4]], [[7], [n4]], [[8], [n4]], [[7], [n4]], 
	[[6], [n4]], [[5], [n4]], [[2], [n2]], 
	[[1], [n4]], [[1], [n4]], [[3], [n2]], 
	[[1], [n4]], [[1], [n4]], [[5], [n2]], 
	[[6], [n4]], [[7], [n4]], [[8], [n4]], [[7], [n4]], 
	[[6], [n4]], [[5], [n4]], [[3], [n2]], 
	[[1], [n4]], [[1], [n4]], [[3], [n4]],[[3], [n4]], 
	[[1], [n4]], [[1], [n4]], [[2], [n4]], [[2], [n4]],
	[[8], [n4]], [[7], [n4]], [[6], [n4]], [[5], [n4]], 
	[[2], [n4]], [[3], [n4]], [[1], [n2]], 
	[[1], [n4]], [[1], [n4]], [[3], [n2]], 
	[[1], [n4]], [[1], [n4]], [[5], [n2]], 
	[[6], [n4]], [[7], [n4]], [[8], [n4]], [[7], [n4]], 
	[[6], [n4]], [[5], [n4]], [[3], [n2]], 
	[[1], [n4]], [[1], [n4]], [[3], [n2]], 
	[[1], [n4]], [[1], [n4]], [[2], [n2]], 
	[[5], [n4]], [[7], [n4]], [[8], [n4]], [[7], [n4]], 
	[[6], [n4]], [[5], [n4]], [[2], [n2]], 
	[[1], [n4]], [[1], [n4]], [[3], [n2]], 
	[[1], [n4]], [[1], [n4]], [[5], [n2]], 
	[[6], [n4]], [[7], [n4]], [[8], [n4]], [[7], [n4]], 
	[[6], [n4]], [[5], [n4]], [[3], [n2]], 
	[[1], [n4]], [[1], [n4]], [[3], [n4]],[[3], [n4]], 
	[[1], [n4]], [[1], [n4]], [[2], [n4]], [[2], [n4]],
	[[8], [n4]], [[7], [n4]], [[6], [n4]], [[5], [n4]], 
	[[2], [n4]], [[3], [n4]], [[1], [n2]], 
]
var musicSpeed = 500
var score = 60

var screen = get_viewport_rect().size
var title = "pinkcandyzhou-毛绒音乐家"

func showLevelInfo():
	$levelInfo/information.text = "
	毛绒音乐家
	作者 pinkcandyzhou
	"
	$levelInfo.show()
	await get_tree().create_timer(5,false).timeout
	while $levelInfo.position.x>-192:
		$levelInfo.position.x -= 5
	$levelInfo.hide()

func showHitBox():
	for i in range(len(hitBoxList)):
		for j in range(len(hitBoxList[i][0])):
			var theKey = hitBoxList[i][0][j]
			var theBox = hitBox.instantiate()
			if theKey!=0:
				theBox.position.x = 192 + 128*(theKey-1)
				theBox.position.y = screen.y
				theBox.key = theKey
				theBox.speed = musicSpeed
				add_child(theBox)
		var toneLength = hitBoxList[i][1][0]
		await get_tree().create_timer(toneLength,false).timeout

func gameOver(score):
	$PauseGame/failedMusic.play()
	$levelMusic.stop()
	get_tree().call_group("hitBoxes","queue_free")
	$PauseGame.gameEnd = true
	$gameEnd.visible = true
	$gameEnd/failed.visible = true

func gameSuccess(score):
	$PauseGame/successMusic.play()
	$gameEnd/success/successScore.text = "得分 "+str(score)
	$levelMusic.stop()
	$PauseGame.gameEnd = true
	$gameEnd.visible = true
	$gameEnd/success.visible = true

func _ready():
	$PauseGame.visible = false
	$gameEnd.visible = false
	$line/lineBody/musicTitle/title.text = title
	showLevelInfo()
	showHitBox()

func _process(delta):
	$line/lineBody/Score/theScore.text = "得分"+" "+str(score)

func _input(event):
	if Input.is_action_just_pressed("hit1"):
		$role.play("hit12")
		$line/lineBody/lines/line1.show()
	if Input.is_action_just_pressed("hit2"):
		$role.play("hit12")
		$line/lineBody/lines/line2.show()
	if Input.is_action_just_pressed("hit3"):
		$role.play("hit34")
		$line/lineBody/lines/line3.show()
	if Input.is_action_just_pressed("hit4"):
		$role.play("hit34")
		$line/lineBody/lines/line4.show()
	if Input.is_action_just_pressed("hit5"):
		$role.play("hit56")
		$line/lineBody/lines/line5.show()
	if Input.is_action_just_pressed("hit6"):
		$role.play("hit56")
		$line/lineBody/lines/line6.show()
	if Input.is_action_just_pressed("hit7"):
		$role.play("hit78")
		$line/lineBody/lines/line7.show()
	if Input.is_action_just_pressed("hit8"):
		$role.play("hit78")
		$line/lineBody/lines/line8.show()

func _on_line_area_entered(area):
	area.canHit = true
	area.work = true
	if !musicPlay:
		musicPlay = true
		await  get_tree().create_timer(n8,false).timeout
		$levelMusic.play()

func _on_line_area_exited(area):
	if !$PauseGame.gameEnd:
		if area.hited:
			score += 1
			if score>100: score=100
		else:
			score -= 5
			if score<=0:
				gameOver(score)
			$role.play("sad")
		area.canHit = false

func _on_level_1_music_finished():
	gameSuccess(score)

func _on_role_animation_finished():
	$role.play("default")
	for i in $line/lineBody/lines.get_children():
		i.hide()
