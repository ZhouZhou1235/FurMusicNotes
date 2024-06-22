extends ColorRect

var select = false
var selectNum = 0

# 预览表 更新状态动画
var musicInfo = [
	[0,"毛绒音符","上下选择乐曲 回车开始演奏","default"],
	[1,"毛绒音乐家","教学乐曲，马上开始音乐！","level1"],
	[2,"敬请期待","pinkcandyzhou 2024.6",""],
]

func showPreview(theList):
	var id
	var title
	var info
	var preview
	for i in range(len(theList)):
		id = theList[0]
		title = theList[1]
		info = theList[2]
		preview = theList[3]
	$title.text = title
	$info.text = info
	$preview.play(preview)
	return id

func selectMusic(selectNum):
	for i in range(len(musicInfo)):
		if musicInfo[i][0]==selectNum:
			showPreview(musicInfo[i])
			break
		else:
			showPreview(musicInfo[0])
		
func _process(delta):
	pass

func _ready():
	selectMusic(selectNum)

func _input(event):
	if select:
		if Input.is_anything_pressed():
			if Input.is_key_pressed(KEY_DOWN):
				selectNum += 1
			if Input.is_key_pressed(KEY_UP):
				selectNum -= 1
			# 关卡入口
			if Input.is_action_just_pressed("ui_accept"):
				if self.selectNum == 1:
					get_tree().change_scene_to_file("res://scenes/level1.tscn")
				elif self.selectNum == 2:
					get_tree().change_scene_to_file("res://scenes/level2.tscn")
			if Input.is_action_just_pressed("ui_left") or Input.is_key_pressed(KEY_A):
				self.visible = false
				select = false
				get_parent().welcome = true
	if selectNum<0: selectNum=0
	if selectNum>=len(musicInfo)-1: selectNum=len(musicInfo)-1
	selectMusic(selectNum)
