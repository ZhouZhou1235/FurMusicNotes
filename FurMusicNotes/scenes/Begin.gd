# 开始界面
# 引导玩家游戏的界面

extends Control

var packageList :Array = []
var begin: bool
var selectNum :int

# 初始化
func init():
	self.set_process(true)
	self.show()
	$Exit.hide()
	begin = false
	selectNum = -1
	$SelectPanel/Start.hide()
	$SelectPanel/HitCount.hide()
	$SelectPanel.hide()
	$SelectPackage/Info.text = GArea.base["GAME_TITLE"]+"-"+GArea.base["GAME_VERSION"]+"\n"+GArea.base["GAME_INFO"]
	$Animate.play("enter")
	$Animate.stop()
	$Hall.play()
	loadPackageList()

# 检索资源文件夹然后加载音乐包列表
func loadPackageList():
	var dir = DirAccess.open(GArea.musicPackagesPath)
	if dir:
		dir.list_dir_begin()
		var fileName = dir.get_next()
		while fileName != "":
			if dir.current_is_dir():
				var indexPath = GArea.musicPackagesPath+fileName+"/index.json"
				var obj = GArea.jsonDecodeFromPath(indexPath)
				var packageName = obj["package"]
				packageList.append({
					"packageName":packageName,
					"packageIndex":indexPath
				})
			fileName = dir.get_next()
	for item in packageList:
		$SelectPackage/PackageList.add_item(item["packageName"])

# 加载音乐包
func loadPackage(packageIndex):
	GArea.musicPackage = GArea.jsonDecodeFromPath(packageIndex)
	$SelectPanel/PackageInfo.text = GArea.musicPackage["package"]+"\n"+GArea.musicPackage["info"]
	GArea.musicList = GArea.musicPackage["musicList"]
	for item in GArea.musicList:
		$SelectPanel/MusicList.add_item(item["worker"]+"-"+item["title"])

# 加载游玩记录
func loadUserPlay():
	var packageName = GArea.musicPackage["package"]
	var packages :Array = GArea.user["packages"]
	var musicList = []
	for item in GArea.musicPackage["musicList"]:
		musicList.append({
			"title":item["title"],
			"hitCount":{"best":0,"great":0,"good":0,"ok":0,"miss":0},
			"score":0,
			"star":0
		})
	var thePackage = {
		"package":GArea.musicPackage["package"],
		"musicList":musicList
	}
	if packages==[] or !GArea.havePackageName(packageName):
		packages.append(thePackage)
		GArea.user["packages"] = packages
		GArea.saveToFile(GArea.userPath,GArea.jsonEncode(GArea.user))

# 加载音乐预览
func loadMusicPreview(listIndex):
	var theItem = GArea.musicList[listIndex]
	$SelectPanel/Preview.texture = ImageTexture.create_from_image(Image.load_from_file(theItem["preview"]))
	$SelectPanel/MusicTitle.text = theItem["title"]
	$SelectPanel/MusicInfo.text = theItem["info"]
	selectNum = listIndex
	if !$SelectPanel/Start.visible: $SelectPanel/Start.show()
	if !$SelectPanel/HitCount.visible: $SelectPanel/HitCount.show()
	var packageIndex = GArea.findThePackageFromList(GArea.musicPackage["package"])[1]
	var theUserItem = GArea.user["packages"][packageIndex]["musicList"][selectNum]
	$SelectPanel/HitCount/Score.text = str(theUserItem["score"])
	$SelectPanel/HitCount/CountPanel/HitBest/Num.text = str(theUserItem["hitCount"]["best"])
	$SelectPanel/HitCount/CountPanel/HitGreat/Num.text = str(theUserItem["hitCount"]["great"])
	$SelectPanel/HitCount/CountPanel/HitGood/Num.text = str(theUserItem["hitCount"]["good"])
	$SelectPanel/HitCount/CountPanel/HitOK/Num.text = str(theUserItem["hitCount"]["ok"])
	$SelectPanel/HitCount/CountPanel/HitMiss/Num.text = str(theUserItem["hitCount"]["miss"])
	if theUserItem["star"]==1:
		$SelectPanel/HitCount/Star.text = str("过关")
		$Animate.play("star1")
	elif theUserItem["star"]==2:
		$SelectPanel/HitCount/Star.text = str("优秀")
		$Animate.play("star2")
	elif theUserItem["star"]==3:
		$SelectPanel/HitCount/Star.text = str("完美")
		$Animate.play("star3")
	else:
		$SelectPanel/HitCount/Star.text = ""
		$SelectPanel/HitCount.hide()

# 清除音乐选择
func clearMusicSelect():
	$SelectPanel/Preview.texture = null
	$SelectPanel/MusicTitle.text = "毛绒音符"
	$SelectPanel/MusicInfo.text = "选择曲目......"
	$SelectPanel/HitCount.hide()
	$SelectPanel/Start.hide()
	selectNum = -1

func _ready():
	self.init()
	print("Begin ok")

func _unhandled_input(_event):
	if Input.is_anything_pressed() and !Input.is_action_just_pressed("fullScreen"):
		if !GArea.playing:
			if !begin:
				if Input.is_action_just_pressed("ui_cancel"):
					if $Exit.visible: $Exit.hide()
					else:
						if !$Animate.is_playing():
							$Exit.show()
							$Animate.play("exit")
				else:
					begin = true
					$Animate.play("enter")
			elif Input.is_action_just_pressed("ui_cancel"):
				begin = false
				$Animate.play_backwards("enter")

func _on_music_list_item_selected(index): loadMusicPreview(index)

func _on_cancel_btn_pressed(): $Exit.hide()

func _on_exit_btn_pressed(): get_tree().quit()

func _on_hall_finished(): $Hall.play()

func _on_clear_exit_btn_pressed():
	var userEmpty = GArea.getFromFile("res://assets/config/user.json")
	GArea.saveToFile(GArea.userPath,userEmpty)
	get_tree().quit()

func _on_package_list_item_activated(index):
	var path = packageList[index]["packageIndex"]
	loadPackage(path)
	loadUserPlay()
	$SelectPackage.hide()
	$SelectPanel.show()
	$Animate.play("choosePackage")
	$SelectPanel/SelectAnimate.play("musicTitleMove")

func _on_rechoose_btn_pressed():
	GArea.musicPackage = {}
	GArea.musicList = []
	clearMusicSelect()
	$SelectPanel/MusicList.clear()
	$Animate.stop()
	$Exit.hide()
	$SelectPackage.show()
	$SelectPanel.hide()
	begin = true
	$Animate.play("enter")

