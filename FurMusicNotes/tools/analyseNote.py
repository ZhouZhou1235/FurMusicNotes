# 解析曲谱
# 解析其它音游的曲谱文件 转换成毛绒音符格式曲谱

import json
import random
import PublicTools

# 对FNF曲谱文件转换
def translateFNFNotes(jsonStr,speed):
    myNotes = []
    notes :list = json.loads(jsonStr)["song"]["notes"]
    for item in notes:
        sectionNotes :list = item["sectionNotes"]
        needHit :bool = item["mustHitSection"]
        for note in sectionNotes:
            # 从顶部下落到判定线的路程为592
            time = round(note[0]/1000,PublicTools.TOOL_ROUND)-592/speed
            key = random.randint(1,2)*note[1]
            # key :int
            # if needHit==True: key=note[1]+5
            # else: key=note[1]+1
            long = round(note[2]/1000,PublicTools.TOOL_ROUND)
            if key>8: key=8
            elif key<1: key=1
            myNotes.append({
                "time":time,
                "key":key,
                "long":long,
                "needHit":needHit,
            })
    return myNotes

# 用FNF曲谱文件创建一个毛绒音符曲谱
def createNotedataByFNF(fnfPathname,outputPathname,speed=500):
    myNotes = []
    notedata = {}
    title = ""
    bpm = 0
    with open(fnfPathname,"r",encoding=PublicTools.TOOL_ENCODING) as f:
        jsonStr = f.read()
        myNotes = translateFNFNotes(jsonStr,speed)
        fnfNotes = json.loads(jsonStr)
        title = fnfNotes["song"]["song"]
        bpm = fnfNotes["song"]["bpm"]
    with open(PublicTools.PATH_notedata,"r",encoding=PublicTools.TOOL_ENCODING) as f:
        notedata = json.loads(f.read())
        notedata["music"] = title
        notedata["bpm"] = bpm
        notedata["speed"] = speed
        notedata["notes"] = myNotes
    with open(outputPathname,"w",encoding=PublicTools.TOOL_ENCODING) as f:
        f.write(json.dumps(notedata,indent=4))

fnfPathname = "D:/programmingArea/Godot4/programs/FurMusicNotes/tools/tmp/tmp1.json"
outputPathname = "D:/programmingArea/Godot4/programs/FurMusicNotes/tools/tmp/tmp2.json"
createNotedataByFNF(fnfPathname,outputPathname)

# noteList = []
# myNotes = []
# for note in noteList:
#     time = note[1]+0.2
#     key = note[0][0]
#     long = note[2]
#     needHit = True
#     myNotes.append({
#         "time":time,
#         "key":key,
#         "long":long,
#         "needHit":needHit,
#     })
# notedata = {}
# title = "Cheese-Snacks-Good"
# bpm = 146
# speed = 500
# with open(PublicTools.PATH_notedata,"r",encoding=PublicTools.TOOL_ENCODING) as f:
#     notedata = json.loads(f.read())
#     notedata["music"] = title
#     notedata["bpm"] = bpm
#     notedata["speed"] = speed
#     notedata["notes"] = myNotes
# with open("D:/programmingArea/Godot4/programs/FurMusicNotes/tools/tmp/tmp3.json","w",encoding=PublicTools.TOOL_ENCODING) as f:
#     f.write(json.dumps(notedata,indent=4))
