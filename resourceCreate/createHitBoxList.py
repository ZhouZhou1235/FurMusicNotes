import sys

hitBoxList = [["musicBegin"]]

while True:
    # hitBoxPosition = list(map(int,input("pos").split(" ")))
    hitBoxPosition = [1]
    note = input("note")
    if note=="q":
        hitBoxList.append(["musicEnd"])
        outStr = str(hitBoxList)
        outStr = outStr.replace("\'","")
        print(outStr)
        sys.exit()
    note = "n"+note
    hitBox = [hitBoxPosition,[note]]
    hitBoxList.append(hitBox)