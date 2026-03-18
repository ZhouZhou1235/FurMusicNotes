import PublicTools
import json

myNotes = []

for i in range(100):
    myNotes.append({
        "time":i/5,
        "key":5,
        "long":0,
        "needHit":True,
    })
outputPathname = "D:/programmingArea/Godot4/programs/FurMusicNotes/tools/tmp/tmp2.json"

with open(PublicTools.PATH_notedata,"r",encoding=PublicTools.TOOL_ENCODING) as f:
    notedata = json.loads(f.read())
    notedata["notes"] = myNotes
with open(outputPathname,"w",encoding=PublicTools.TOOL_ENCODING) as f:
    f.write(json.dumps(notedata,indent=4))
