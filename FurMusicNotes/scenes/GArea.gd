# 全局空间
# 游戏运行全程始终可用

extends Node

var userPath = "user://play/user.json"
var musicPackagesPath = "user://musicPackages/"
var base :Dictionary
var user :Dictionary
var musicPackage :Dictionary
var musicList :Array
var playing :bool = false

# 从路径解析json对象
func jsonDecodeFromPath(path):
	var jsonStr = FileAccess.get_file_as_string(path)
	var gdObj = JSON.parse_string(jsonStr)
	return gdObj

# 解析json对象
func jsonDecode(jsonStr): return JSON.parse_string(jsonStr)

# 编码json对象
func jsonEncode(obj): return JSON.stringify(obj,"\t")

# 保存内容到文件
func saveToFile(pathname,content):
	var f = FileAccess.open(pathname,FileAccess.WRITE)
	f.store_string(content)
	f.close()

# 用户音乐包列表是否有目标音乐包
func havePackageName(packageName):
	for package in GArea.user["packages"]:
		if package["package"]==packageName: return true
	return false

# 找到当前曲子的列表项
func findTheMusicFromList(title):
	var index = 0
	for item in musicList:
		if item["title"]==title:
			return [item,index]
		index += 1
	return false

# 找到当前音乐包的列表项
func findThePackageFromList(packageName):
	var index = 0
	for item in user["packages"]:
		if item["package"]==packageName:
			return [item,index]
		index += 1
	return false

# 读取一个文件
func getFromFile(pathname):
	var f = FileAccess.open(pathname,FileAccess.READ)
	var content = f.get_as_text()
	return content

func _ready():
	base = jsonDecodeFromPath("res://assets/config/base.json")
	user = jsonDecodeFromPath(userPath)
	print("GArea ok")
